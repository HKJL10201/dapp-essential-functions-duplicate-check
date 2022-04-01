pragma solidity 0.7.4;
pragma experimental ABIEncoderV2;


import "@0xsequence/erc-1155/contracts/mocks/ERC1155MintBurnMock.sol";

contract ERC1155Mock is ERC1155MintBurnMock {

  constructor() ERC1155MintBurnMock('ERC1155Mock', "") {}

}