//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interface/ISemaphore.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ERC721 {
    function balanceOf(address owner) external view returns (uint balance);
}

contract Agenda is Ownable {

    struct AgendaItem {
        address owner;
        string title;
        string description;
    }

    error Feedback__UserAlreadyExists();

    event NewFeedback(uint feedback);
    event NewUser(bytes32 username, uint identifyCommitment);
    event CreateAgenda(uint groupId, address indexed creator);

    uint256 public constant MERKLE_TREE_DEPTH = 20;

    ISemaphore public semaphore;
    address public nftAddress;
    address[] public adminAddressesArray;
    uint256 public numberOfAgendas = 0;

    mapping(uint256 => AgendaItem) public agendas;
    mapping(address => bool) public adminAddresses;
    mapping(address => mapping(bytes32 => uint)) private users;

    constructor(address _semaphoreAddress, address _nftAddress) {
        semaphore = ISemaphore(_semaphoreAddress);
        nftAddress = _nftAddress;
        adminAddresses[msg.sender] = true;
        adminAddressesArray.push(msg.sender);
    }

    function getAdminAddressList() external view returns(address[] memory) {
        return adminAddressesArray;
    }

    /// @dev Access modifier for Admin-only functionality
    modifier onlyAdmin() {
        require(adminAddresses[msg.sender]);
        _;
    }

    function createAgenda(string memory _title, string memory _description, uint _agendaId) external onlyAdmin {
        AgendaItem storage agenda = agendas[numberOfAgendas];

        agenda.owner = msg.sender;
        agenda.title = _title;
        agenda.description = _description;

        numberOfAgendas++;

        semaphore.createGroup(_agendaId, MERKLE_TREE_DEPTH, address(this));
        emit CreateAgenda(_agendaId, address(this));
    }

    function joinAgenda(uint _agendaId, uint _identityCommitment, bytes32 _username) external {
        ERC721 nftContract = ERC721(nftAddress);
        require(nftContract.balanceOf(msg.sender) > 0, "you dont have NFT");
        if (users[msg.sender][_username] != 0) {
            revert Feedback__UserAlreadyExists();
        }

        semaphore.addMember(_agendaId, _identityCommitment);

        users[msg.sender][_username] = _identityCommitment;

        emit NewUser(_username, _identityCommitment);
    }

    function sendFeedback(
        uint _agendaId,
        uint _feedback,
        uint _merkleTreeRoot,
        uint _nullifierHash,
        uint[8] calldata _proof
    ) external {
        semaphore.verifyProof(_agendaId, _merkleTreeRoot, _feedback, _nullifierHash, _agendaId, _proof);
        emit NewFeedback(_feedback);
    }

    function getUserInfo(bytes32 _username) external view returns(uint){
        require(users[msg.sender][_username] != 0, "there is no user");
        return users[msg.sender][_username];
    }

    function setNftAddress(address _newNftAddress) external onlyOwner {
        require(_newNftAddress != address(0), "new address is the zero address");
        nftAddress = _newNftAddress;
    }

    /// @dev Adds a admin address
    function addAdminAddress(address _address) external onlyOwner {
        require(!adminAddresses[_address], "Address is already an admin");
        adminAddresses[_address] = true;
        adminAddressesArray.push(_address);
    }

    /// @dev Removes a admin address
    function removeAdminAddress(address _address) external onlyOwner {
        require(adminAddresses[_address], "Address is not an admin");
        adminAddresses[_address] = false;

        // Remove from the array
        for (uint i = 0; i < adminAddressesArray.length; i++) {
            if (adminAddressesArray[i] == _address) {
                adminAddressesArray[i] = adminAddressesArray[adminAddressesArray.length - 1];
                adminAddressesArray.pop();
                break;
            }
        }
    }
}
