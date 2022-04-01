pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract Projects {
    struct Project {
        uint256 id;
        string name;
        string description;
        uint256 voteCount;
    }

    constructor() public {
        //utf-8 encoded
        addProject("\x56\x69\xC5\xA1\x65\x20\x6B\x6F\xC5\xA1\x65\x76\x61\x20\x7A\x61\x20\x73\x6D\x65\xC4\x87\x65", "\x53\x76\x61\x6B\x6F\x6D\x20\x67\x72\x61\x64\x75\x20\x70\x6F\x74\x72\x65\x62\x6E\x69\x20\x73\x75\x20\x6B\x6F\xC5\xA1\x65\x76\x69\x20\x7A\x61\x20\x73\x6D\x65\xC4\x87\x65\x2E\x20\x54\x72\x65\x6E\x75\x74\x6E\x6F\x20\x69\x68\x20\x6E\x69\x6A\x65\x20\x64\x6F\x76\x6F\x6C\x6A\x6E\x6F\x20\x69\x20\x7A\x62\x6F\x67\x20\x74\x6F\x67\x61\x20\x67\x72\x61\xC4\x91\x61\x6E\x69\x20\x62\x61\x63\x61\x6A\x75\x20\x6F\x74\x70\x61\x64\x20\x75\x20\x70\x72\x69\x72\x6F\x64\x75\x20\x69\x6C\x69\x20\x67\x61\x20\x6E\x6F\x73\x65\x20\x73\x76\x6F\x6A\x69\x6D\x20\x6B\x75\xC4\x87\x61\x6D\x61\x20\x6B\x61\x6B\x6F\x20\x62\x69\x20\x67\x61\x20\x7A\x62\x72\x69\x6E\x75\x6C\x69\x2E\x20\xC5\xBD\x65\x6C\x69\x6D\x6F\x20\xC4\x8D\x69\x73\x74\x20\x69\x20\x75\x72\x65\x64\x61\x6E\x20\x67\x72\x61\x64\x2C\x20\x7A\x61\x72\x20\x6E\x65\x3F\x20\x55\x6B\x6F\x6C\x69\x6B\x6F\x20\x73\x65\x20\x73\x6C\x61\xC5\xBE\x65\x74\x65\x2C\x20\x67\x6C\x61\x73\x61\x6A\x74\x65\x2E");
        addProject("\x43\x6F\x77\x6F\x72\x6B\x69\x6E\x67\x20\x70\x72\x6F\x73\x74\x6F\x72\x69", "\x20\x4B\x6F\x64\x20\x6B\x75\xC4\x87\x65\x20\x6E\x65\x6D\x61\x74\x65\x20\x61\x64\x65\x6B\x76\x61\x74\x61\x6E\x20\x70\x72\x6F\x73\x74\x6F\x72\x20\x7A\x61\x20\x72\x61\x64\x3F\x20\x54\x72\x65\x62\x61\x20\x76\x61\x6D\x20\x6D\x69\x72\x61\x3F\x20\xC5\xBD\x65\x6C\x69\x74\x65\x20\x75\x64\x6F\x62\x6E\x69\x6A\x75\x20\x73\x74\x6F\x6C\x69\x63\x75\x3F\x20\x42\x6F\x6C\x6A\x65\x20\x6F\x73\x76\x6A\x65\x74\x6C\x6A\x65\x6E\x6A\x65\x3F\x20\x49\x6E\x74\x65\x72\x6E\x65\x74\x3F\x20\x53\x76\x65\x3F\x20\x4E\x65\x20\xC5\xBE\x65\x6C\x69\x74\x65\x20\x7A\x61\x6B\x75\x70\x69\x74\x69\x20\x70\x6F\x73\x6C\x6F\x76\x6E\x69\x20\x70\x72\x6F\x73\x74\x6F\x72\x2C\x20\x61\x20\x69\x70\x61\x6B\x20\xC5\xBE\x65\x6C\x69\x74\x65\x20\x69\x6D\x61\x74\x69\x20\x6D\x6A\x65\x73\x74\x6F\x20\x67\x64\x6A\x65\x20\x6D\x6F\xC5\xBE\x65\x74\x65\x20\x72\x61\x64\x69\x74\x69\x3F\x20\x43\x6F\x77\x6F\x72\x6B\x69\x6E\x67\x20\x70\x72\x6F\x73\x74\x6F\x72\x69\x20\x73\x75\x20\x72\x6A\x65\xC5\xA1\x65\x6E\x6A\x65\x21\x20\x47\x6C\x61\x73\x61\x6A\x74\x65\x2E\x20");
        addProject("\x50\x61\x6D\x65\x74\x6E\x61\x20\x6A\x61\x76\x6E\x61\x20\x72\x61\x73\x76\x6A\x65\x74\x61", "\x53\x76\x6A\x65\x74\x6C\x6F\x73\x6E\x6F\x20\x6F\x6E\x65\xC4\x8D\x69\xC5\xA1\xC4\x87\x65\x6E\x6A\x65\x20\x6F\x6B\x6F\x6C\x69\xC5\xA1\x61\x20\x6E\x69\x73\x75\x20\x72\x69\x6A\x65\xC4\x8D\x69\x20\x6B\x6F\x6A\x65\x20\xC4\x8D\x65\x73\x74\x6F\x20\xC4\x8D\x75\x6A\x65\x74\x65\x2C\x20\x6E\x6F\x20\x6F\x6E\x65\x20\x73\x75\x20\x73\x74\x76\x61\x72\x6E\x6F\x73\x74\x2E\x20\x4E\x65\x67\x61\x74\x69\x76\x61\x6E\x20\x75\x74\x6A\x65\x63\x61\x6A\x20\x6E\x61\x20\x62\x69\x6C\x6A\x6E\x69\x20\x69\x20\xC5\xBE\x69\x76\x6F\x74\x69\x6E\x6A\x73\x6B\x69\x20\x73\x76\x69\x6A\x65\x74\x2C\x20\x6F\x6D\x65\x74\x61\x6E\x6A\x65\x20\x73\x75\x64\x69\x6F\x6E\x69\x6B\x61\x20\x75\x20\x70\x72\x6F\x6D\x65\x74\x75\x2C\x20\x65\x6E\x65\x72\x67\x65\x74\x73\x6B\x61\x20\x6E\x65\x75\xC4\x8D\x69\x6E\x6B\x6F\x76\x69\x74\x6F\x73\x74\x20\x73\x61\x6D\x6F\x20\x73\x75\x20\x6F\x64\x20\x70\x61\x72\x20\x70\x72\x6F\x62\x6C\x65\x6D\x61\x20\x6B\x6F\x6A\x65\x20\x6F\x6E\x6F\x20\x64\x6F\x6E\x6F\x73\x69\x2E\x20\x50\x61\x6D\x65\x74\x6E\x61\x20\x72\x61\x73\x76\x6A\x65\x74\x61\x20\x72\x6A\x65\xC5\xA1\x61\x76\x61\x20\x73\x74\x76\x61\x72\x21\x20\x49\x20\x7A\x62\x6F\x67\x20\x74\x6F\x67\x61\x2E\x2E\x2E\x20\x67\x6C\x61\x73\x61\x6A\x74\x65\x2E");
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectsCount;

    mapping(address => bool) public voters;

    function addProject(string memory _name, string memory _description)
        private
    {
        projectsCount++;
        projects[projectsCount] = Project(
            projectsCount,
            _name,
            _description,
            0
        );
    }

    function getVotedCount() public view returns (uint256 count) {
        for (uint256 i = 1; i <= projectsCount; i++) {
            count += projects[i].voteCount;
        }
        return count;
    }

    function vote(uint256 _projectId) public {
        //checking that this address hasn't voted before
        require(!voters[msg.sender]);
        //make sure that projectid is valid
        require(_projectId > 0 && _projectId <= projectsCount);
        //setting that a voter has voted
        voters[msg.sender] = true;
        //incrementing votecount for project
        projects[_projectId].voteCount++;
    }
}