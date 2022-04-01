pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract MultiiSig {
    
    address mainOwner;
    address[] walletowners;
    uint limit;
    uint depositId = 0;
    uint withdrawalId = 0;
    uint transferId = 0;
    string[] tokenList;
    
    
    constructor() {
        
        mainOwner = msg.sender;
        walletowners.push(mainOwner);
        limit = walletowners.length - 1;
        tokenList.push("ETH");
    }
    
    mapping(address => mapping(string => uint)) balance;
    mapping(address => mapping(uint => bool)) approvals;
    mapping(string => Token) tokenMapping;
    
    struct Token {
        
        string ticker;
        address tokenAddress;
    }
    
    struct Transfer {
        
        string ticker;
        address sender;
        address payable receiver;
        uint amount;
        uint id;
        uint approvals;
        uint timeOfTransaction;
    }
    
    Transfer[] transferRequests;
    
    event walletOwnerAdded(address addedBy, address ownerAdded, uint timeOfTransaction);
    event walletOwnerRemoved(address removedBy, address ownerRemoved, uint timeOfTransaction);
    event fundsDeposited(string ticker, address sender, uint amount, uint depositId, uint timeOfTransaction);
    event fundsWithdrawed(string ticker, address sender, uint amount, uint withdrawalId, uint timeOfTransaction);
    event transferCreated(string ticker, address sender, address receiver, uint amount, uint id, uint approvals, uint timeOfTransaction);
    event transferCancelled(string ticker, address sender, address receiver, uint amount, uint id, uint approvals, uint timeOfTransaction);
    event transferApproved(string ticker, address sender, address receiver, uint amount, uint id, uint approvals, uint timeOfTransaction);
    event fundsTransfered(string ticker, address sender, address receiver, uint amount, uint id, uint approvals, uint timeOfTransaction);
    event tokenAdded(address addedBy, string ticker, address tokenAddress, uint timeOfTransaction);
    
    modifier onlyowners() {
        
       bool isOwner = false;
       for (uint i = 0; i< walletowners.length; i++) {
           
           if (walletowners[i] == msg.sender) {
               
               isOwner = true;
               break;
           }
       }
       
       require(isOwner == true, "only wallet owners can call this function");
       _;
        
    }
    
    modifier tokenExists(string memory ticker) {
        
        require(tokenMapping[ticker].tokenAddress != address(0), "token does not exixts");
        _;
    }
    
    function addToken(string memory ticker, address _tokenAddress) public onlyowners {
        
        for (uint i = 0; i < tokenList.length; i++) {
            
            require(keccak256(bytes(tokenList[i])) != keccak256(bytes(ticker)), "cannot add duplicate tokens");
        }
        
        require(keccak256(bytes(ERC20(_tokenAddress).symbol())) == keccak256(bytes(ticker)));
        
        tokenMapping[ticker] = Token(ticker, _tokenAddress);
        
        tokenList.push(ticker);
        
        emit tokenAdded(msg.sender, ticker, _tokenAddress, block.timestamp);
    }
   
    
    
    
    function addWalletOwner(address owner) public onlyowners {
        
        
       for (uint i = 0; i < walletowners.length; i++) {
           
           if(walletowners[i] == owner) {
               
               revert("cannot add duplicate owners");
           }
       }
        
        walletowners.push(owner);
        limit = walletowners.length - 1;
        
        emit walletOwnerAdded(msg.sender, owner, block.timestamp);
    }
    
    
    function removeWalletOwner(address owner) public onlyowners {
        
        bool hasBeenFound = false;
        uint ownerIndex;
        for (uint i = 0; i < walletowners.length; i++) {
            
            if(walletowners[i] == owner) {
                
                hasBeenFound = true;
                ownerIndex = i;
                break;
            }
        }
        
        require(hasBeenFound == true, "wallet owner not detected");
        
        walletowners[ownerIndex] = walletowners[walletowners.length - 1];
        walletowners.pop();
        limit = walletowners.length - 1;
        
         emit walletOwnerRemoved(msg.sender, owner, block.timestamp);
       
    }
    
    function deposit(string memory ticker, uint amount) public payable onlyowners {
        
        require(balance[msg.sender][ticker] >= 0, "cannot deposiit a calue of 0");
        
        if(keccak256(bytes(ticker)) == keccak256(bytes("ETH"))) {
            
            balance[msg.sender]["ETH"] = msg.value;
            
        }
        
        else {
            
            require(tokenMapping[ticker].tokenAddress != address(0), "token does not exixts");
            balance[msg.sender][ticker] += amount;
            IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
           
        }
        
        emit fundsDeposited(ticker, msg.sender, msg.value, depositId, block.timestamp);
         
        depositId++;
        
    } 
    
    
    
    function withdraw(string memory ticker, uint amount) public onlyowners {
        
        require(balance[msg.sender][ticker] >= amount);
        
        balance[msg.sender][ticker] -= amount;
        
        if(keccak256(bytes(ticker)) == keccak256(bytes("ETH"))) {
            
            payable(msg.sender).transfer(amount);
        }
        
        else {
            
            require(tokenMapping[ticker].tokenAddress != address(0), "token does not exixts");
            IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);
            
        }
        
        emit fundsWithdrawed(ticker, msg.sender, amount, withdrawalId, block.timestamp);
        
        withdrawalId++;
        
    }
    
    function createTrnasferRequest(string memory ticker, address payable receiver, uint amount) public onlyowners {
        
        require(balance[msg.sender][ticker] >= amount, "insufficent funds to create a transfer");
        
        for (uint i = 0; i < walletowners.length; i++) {
            
            require(walletowners[i] != receiver, "cannot transfer funds withiwn the wallet");
        }
        
        balance[msg.sender][ticker] -= amount;
        transferRequests.push(Transfer(ticker, msg.sender, receiver, amount, transferId, 0, block.timestamp));
        transferId++;
        emit transferCreated(ticker, msg.sender, receiver, amount, transferId, 0, block.timestamp);
    }
    
    function cancelTransferRequest(uint id) public onlyowners {
        
         string memory ticker = transferRequests[id].ticker;
        bool hasBeenFound = false;
        uint transferIndex = 0;
        for (uint i = 0; i < transferRequests.length; i++) {
            
            if(transferRequests[i].id == id) {
                
                hasBeenFound = true;
                break;
               
            }
            
             transferIndex++;
        }
        
        require(transferRequests[transferIndex].sender == msg.sender, "only the transfer creator can cancel");
        require(hasBeenFound, "transfer request does not exist");
        
        balance[msg.sender][ticker] += transferRequests[transferIndex].amount;
        
        transferRequests[transferIndex] = transferRequests[transferRequests.length - 1];
        
        emit transferCancelled(ticker, msg.sender, transferRequests[transferIndex].receiver, transferRequests[transferIndex].amount, transferRequests[transferIndex].id, transferRequests[transferIndex].approvals, transferRequests[transferIndex].timeOfTransaction);
        transferRequests.pop();
    }
    
    function approveTransferRequest(uint id) public onlyowners {
        
        string memory ticker = transferRequests[id].ticker;
        bool hasBeenFound = false;
        uint transferIndex = 0;
        for (uint i = 0; i < transferRequests.length; i++) {
            
            if(transferRequests[i].id == id) {
                
                hasBeenFound = true;
                break;
                
            }
            
             transferIndex++;
        }
        
        require(hasBeenFound, "only the transfer creator can cancel");
        require(approvals[msg.sender][id] == false, "cannot approve the same transfer twice");
        require(transferRequests[transferIndex].sender != msg.sender);
        
        approvals[msg.sender][id] = true;
        transferRequests[transferIndex].approvals++;
        
        emit transferApproved(ticker, msg.sender, transferRequests[transferIndex].receiver, transferRequests[transferIndex].amount, transferRequests[transferIndex].id, transferRequests[transferIndex].approvals, transferRequests[transferIndex].timeOfTransaction);
        
        if (transferRequests[transferIndex].approvals == limit) {
            
            transferFunds(ticker, transferIndex);
        }
    }
    
    function transferFunds(string memory ticker, uint id) private {
        
        balance[transferRequests[id].receiver][ticker] += transferRequests[id].amount;
        
        if(keccak256(bytes(ticker)) == keccak256(bytes("ETH"))) {
            
            transferRequests[id].receiver.transfer(transferRequests[id].amount);
        }
        else {
            
            IERC20(tokenMapping[ticker].tokenAddress).transfer(transferRequests[id].receiver, transferRequests[id].amount);
        }
       
        
        emit fundsTransfered(ticker, msg.sender, transferRequests[id].receiver, transferRequests[id].amount, transferRequests[id].id, transferRequests[id].approvals, transferRequests[id].timeOfTransaction);
        
        transferRequests[id] = transferRequests[transferRequests.length - 1];
        transferRequests.pop();
    }
    
    function getApprovals(uint id) public view returns(bool) {
        
        return approvals[msg.sender][id];
    }
    
    function getTransferRequests() public view returns(Transfer[] memory) {
        
        return transferRequests;
    }
    
    function getBalance(string memory ticker) public view returns(uint) {
        
        return balance[msg.sender][ticker];
    }
    
    function getApprovalLimit() public view returns (uint) {
        
        return limit;
    }
    
     function getContractBalance() public view returns(uint) {
        
        return address(this).balance;
    }
    
    function getWalletOners() public view returns(address[] memory) {
        
        return walletowners;
    }
   
    
    
}