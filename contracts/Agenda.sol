// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./AccessControl.sol";
import "./interface/ISemaphore.sol";

contract Agenda is AccessControl {

    struct AgendaItem {
        address owner;
        string title;
        string description;
        uint256 deadline;
    }

    event NewAgenda(uint agenda);
    event NewUser(bytes32 username, uint identifyCommitment);
    event CreateAgenda(uint groupId, address indexed creator);

    ISemaphore public semaphore;
    address public nftAddress;
    uint256 public numberOfAgendas; // initial value = 0

    mapping(uint256 => Agenda) public agendas;
    mapping(address => mapping(bytes32 => uint256)) private users;

    constructor(address _semaphore, address _nft) {
        semaphore = ISemaphore(_semaphore);
        nftAddress = _nft;
    }

    function createAgenda(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _deadline,
        uint256 _agendaId
    ) external onlyAdmin {}

    function joinAgenda(uint256 _agendaId, uint256 _identityCommitment, bytes32 _username) external {}

    function sendFeedback(
        uint256 _agendaId,
        uint256 _feedback,
        uint256 _merkleTreeRoot,
        uint256 _nullifierHash,
        uint256[8] calldata _proof
    ) external {}

    function getUserInfo(bytes32 _username) external view returns(uint) {
        require(users[msg.sender][_username] != 0, "user is not exists");
        return users[msg.sender][_username];
    }

    function setNftAddress(address _newNftAddress) external onlyOwner {
        require(_newNftAddress != address(0), "invalid address");
        nftAddress = _newNftAddress;
    }



}