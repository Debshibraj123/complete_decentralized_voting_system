// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
        uint age; // Age of the voter
        string id; // Voter's identification
    }

    address public owner;
    string public electionName;

    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;

    modifier ownerOnly() {
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    constructor(string memory _name) {
        owner = msg.sender;
        electionName = _name;
    }

    function addCandidate(string memory _name) ownerOnly public {
        candidates.push(Candidate(candidates.length, _name, 0));
    }

    // Updated to include age and id for authorization
    function authorizeVoter(address _person, uint _age, string memory _id) ownerOnly public {
        require(_age >= 18, "Voter must be at least 18 years old.");
        voters[_person] = Voter(true, false, 0, _age, _id);
    }

    function vote(uint _voteIndex) public {
        require(!voters[msg.sender].voted, "Already voted.");
        require(voters[msg.sender].authorized, "Not authorized to vote.");

        voters[msg.sender].vote = _voteIndex;
        voters[msg.sender].voted = true;

        candidates[_voteIndex].voteCount += 1;
        totalVotes += 1;
    }

    function endVote() ownerOnly public view returns (string memory _winnerName) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                _winnerName = candidates[i].name;
            }
        }
    }
}
