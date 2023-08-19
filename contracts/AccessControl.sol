// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessControl is Ownable {

    mapping(address => bool) public isAdminAddress;
    address[] public admins;

    event AdminAdded(address indexed newAdmin);
    event AdminRemoved(address indexed oldAdmin);

    modifier onlyAdmin() {
        require(isAdminAddress[msg.sender], "Caller is not an admin");
        _;
    }

    constructor() {
        isAdminAddress[msg.sender] = true;
        admins.push(msg.sender);
    }

    function createAdmin(address _newAdmin) external onlyOwner {
        require(!isAdminAddress[_newAdmin], "Address is already an admin");
        isAdminAddress[_newAdmin] = true;
        admins.push(_newAdmin);
        emit AdminAdded(_newAdmin);
    }

    function removeAdmin(address _OldAdmin) external onlyOwner {
        require(isAdminAddress[_OldAdmin], "Address is not an admin");
        isAdminAddress[_OldAdmin] = false;
        for(uint i = 0; i < admins.length; i++) {
            if(admins[i] == _OldAdmin) {
                admins[i] = admins[admins.length - 1];
                admins.pop();
                break;
            }
        }
        emit AdminRemoved(_OldAdmin);
    }

    function getAdminList() external view returns(address[] memory) {
        return admins;
    }
}