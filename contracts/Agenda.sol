// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./AccessControl.sol";
import "./interface/ISemaphore.sol";
import "./NftHelper.sol";

contract Agenda is AccessControl {

    struct AgendaItem {
        address owner;
        string title;
        string description;
        uint256 deadline;
    }

    uint256 private constant MERKLE_TREE_DEPTH = 20;

    error Feedback__UserAlreadyExists();

    event NewFeedback(uint feedback);
    event NewUser(bytes32 username, uint identifyCommitment);
    event CreateAgenda(uint groupId, address indexed creator);

    ISemaphore public semaphore;
    NftHelper public nftHelper;
    uint256 public numberOfAgendas;

    mapping(uint256 => AgendaItem) public agendas;
    mapping(address => mapping(bytes32 => uint256)) private users;

    constructor(address _semaphore, address _nftHelper) {
        semaphore = ISemaphore(_semaphore);
        nftHelper = NftHelper(_nftHelper);
    }

    function createAgenda(
        string memory _title,
        string memory _description,
        uint256 _deadline,
        uint256 _agendaId
    ) external onlyAdmin {
        AgendaItem storage agenda = agendas[numberOfAgendas];

        agenda.owner = msg.sender;
        agenda.title = _title;
        agenda.description = _description;
        agenda.deadline = _deadline;

        numberOfAgendas++;

        semaphore.createGroup(_agendaId, MERKLE_TREE_DEPTH, address(this));
        emit CreateAgenda(_agendaId, address(this));
    }

    function joinAgenda(uint256 _agendaId, uint256 _identityCommitment, bytes32 _username) external {
        require(nftHelper.userHasNft(msg.sender), "NFT is not exists");
        if (users[msg.sender][_username] != 0) {
            revert Feedback__UserAlreadyExists();
        }

        semaphore.addMember(_agendaId, _identityCommitment);

        users[msg.sender][_username] = _identityCommitment;

        emit NewUser(_username, _identityCommitment);

    }

    function sendFeedback(
        uint256 _agendaId,
        uint256 _feedback,
        uint256 _merkleTreeRoot,
        uint256 _nullifierHash,
        uint256[8] calldata _proof
    ) external {
        semaphore.verifyProof(_agendaId, _merkleTreeRoot, _feedback, _nullifierHash, _agendaId, _proof);
        emit NewFeedback(_feedback);
    }

    function getUserInfo(bytes32 _username) external view returns(uint) {
        require(users[msg.sender][_username] != 0, "user is not exists");
        return users[msg.sender][_username];
    }
}
