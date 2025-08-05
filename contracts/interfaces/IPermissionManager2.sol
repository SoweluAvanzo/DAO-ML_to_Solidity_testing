// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IPermissionManager {
    function has_permission(address user, uint8 permissionIndex) external view returns (bool);
}
