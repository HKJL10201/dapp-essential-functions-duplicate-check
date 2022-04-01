pragma solidity ^0.5.0;

contract Election {
    //Model the candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    //Store accounts that have voted
    mapping(address => bool) public voters;
    //Store Canditates
    //Fetch Candidate
    mapping(uint256 => Candidate) public candidates;
    //Store Candidates Count
    uint256 public candidatesCount;

    //user voted event
    event votedEvent(uint256 indexed _candidateId);

    constructor() public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint256 _candidateId) public {
        //require that they haven't voted before
        require(!voters[msg.sender], "Voter has already voted");
        //require a valid candidate
        require(
            _candidateId > 0 && _candidateId <= candidatesCount,
            "Candidate doesn't exist"
        );
        //record a voter has voted
        voters[msg.sender] = true;
        //update candidate count
        candidates[_candidateId].voteCount++;

        //trigger event
        emit votedEvent(_candidateId);
    }
}
