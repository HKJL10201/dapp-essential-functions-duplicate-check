pragma solidity ^0.4.18;

contract Voting {
    /*
  The mapping key is the candidates name stored as bytes32 and the mapping value is the vote count stored as uint8.
  */
    mapping(bytes32 => uint8) public votesReceived;

    /*
  An array of bytes32 to store the list of candidates.
  */
    bytes32[] public candidateList;

    /*
  Get the candidates.
  */
    function getCandidateList() constant returns (bytes32[]) {
        return candidateList;
    }

    /*
  The constructor will only be called once when the contract is deployed. 
  When we deploy the contract we will pass an array of candidates who will be participating in the election.
  */
    function Voting(bytes32[] candidateNames) public {
        candidateList = candidateNames;
    }

    /*
  Returns the total votes for a given candidate.
  */
    function totalVotesFor(bytes32 candidate) public view returns (uint8) {
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    /*
  Increment the vote count for a given candidate.
  */
    function voteForCandidate(bytes32 candidate) public {
        require(validCandidate(candidate));
        votesReceived[candidate] += 1;
    }

    /*
  Determine if a given candidate exists.
  */
    function validCandidate(bytes32 candidate) public view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }
}
