pragma solidity ^0.4.17;

contract Voting {
    struct Proposal {
        string title;
        uint256 voteCountPos;
        uint256 voteCountNeg;
        uint256 voteCountAbs;
        mapping(address => Voter) voters;
        address[] votersAddress;
    }

    struct Voter {
        uint256 value;
        bool voted;
    }

    Proposal[] public proposals;

    event CreatedProposalEvent();
    event CreatedVoteEvent();

    function getNumProposals() public view returns (uint256) {
        return proposals.length;
    }

    function getProposal(uint256 proposalInt)
        public
        view
        returns (
            uint256,
            string,
            uint256,
            uint256,
            uint256,
            address[]
        )
    {
        if (proposals.length > 0) {
            Proposal storage p = proposals[proposalInt]; // Get the proposal
            return (
                proposalInt,
                p.title,
                p.voteCountPos,
                p.voteCountNeg,
                p.voteCountAbs,
                p.votersAddress
            );
        }
    }

    function addProposal(string title) public returns (bool) {
        Proposal memory proposal;
        CreatedProposalEvent();
        proposal.title = title;
        proposals.push(proposal);
        return true;
    }

    function vote(uint256 proposalInt, uint256 voteValue)
        public
        returns (bool)
    {
        if (proposals[proposalInt].voters[msg.sender].voted == false) {
            // check duplicate key
            require(voteValue == 1 || voteValue == 2 || voteValue == 3); // check voteValue
            Proposal storage p = proposals[proposalInt]; // Get the proposal
            if (voteValue == 1) {
                p.voteCountPos += 1;
            } else if (voteValue == 2) {
                p.voteCountNeg += 1;
            } else {
                p.voteCountAbs += 1;
            }
            p.voters[msg.sender].value = voteValue;
            p.voters[msg.sender].voted = true;
            p.votersAddress.push(msg.sender);
            CreatedVoteEvent();
            return true;
        } else {
            return false;
        }
    }
}
