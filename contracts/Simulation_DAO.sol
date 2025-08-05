// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * @title Simulation_DAO
 * @notice None
 */
import "./interfaces/IPermissionManager2.sol";
contract Simulation_DAO is IPermissionManager {
    bool internal committee_initialization_blocked;
    mapping(address => uint32) internal roles;
    uint8[4] internal role_permissions;
    uint32[4] internal all_roles = [
        256, // #0) Role1 -> ID : 0 , control bitmask: 1000
        257, // #1) Role2 -> ID : 1 , control bitmask: 1000
        258, // #2) Role3 -> ID : 2 , control bitmask: 1000
        259 // #3) Simulation_DAOOwner -> ID : 3 , control bitmask: 1000
    ];
 //Events
    event RoleRevoked(address indexed user, uint32 indexed role);
    event RoleAssigned(address indexed user, uint32 indexed role);
    event PermissionGranted(uint32 indexed role, uint8 indexed permission);
    event PermissionRevoked(uint32 indexed role, uint8 indexed permission);



        modifier controlledBy(address sender, uint32 user_role_id, bool allowNullRole_user, uint32 new_role_id) {
            //we obtain the control relations of the controller role by shifting the its id by the number of bits contained in ids
            //the sender must control BOTH the target role AND the user's role

            uint32 index_new_role = new_role_id & 31;
            uint32 sender_role_index = ( uint32(1) << ( roles[sender] & 31 ) );

            require(
                ( // the new role must be a valid one
                    index_new_role < 4 // checking for "index out of bounds"
                )
                && ( // "check the sender and target user control relation"
                    (allowNullRole_user && (user_role_id == 0)) || // allow to add role if the user doesn't have one
                    ((
                        (user_role_id >> 5) // get the user role's bitmask 
                        &  // (... and then perform the bitwise-and with ...)
                        sender_role_index
                    ) != 0) // final check
                ) &&
                ( // "control relation check between sender and the target role"
                    (
                        ( all_roles[index_new_role] >> 5) // get the new role's bitmask from those internally stored
                        &  // (... and then perform the bitwise-and with ...)
                        sender_role_index
                    ) != 0 // final check
                )
                , "the given controller can't perform the given operation on the given controlled one" );
            _;
        }
        


 
    modifier hasPermission(address _executor, uint8 _permissionIndex) {
        require(role_permissions[uint8(roles[_executor] & 31)] & (uint8(1) << _permissionIndex) != 0, "User does not have this permission");
        _;
    }
            
    constructor(
) {
        role_permissions[0] = 1; // #0) Role1 

        role_permissions[1] = 7; // #1) Role2 

        role_permissions[2] = 63; // #2) Role3 

        role_permissions[3] = 63; // #3) Simulation_DAOOwner 

roles[msg.sender] = all_roles[3]; // Simulation_DAOOwner
}
    function initializeCommittees() external {
        require(roles[msg.sender] == all_roles[3], "Only the owner can initialize the Dao");  // Simulation_DAOOwner
    }

        
        function canControl(uint32 controller, uint32 controlled) public pure returns(bool controls){
             // ( "CAN the sender control the target user (through its role)?"
                //(allowNullRole && (target_role_id == 0)) || // allow to add role if the user has not already one assigned to it
                if((
                    (controlled >> 5 ) // get the role's bitmask 
                    &  // (and then perform the bitwise-and with ...)
                    (uint32(1) << ( controller & 31 )) // (...) get the sender role's index AND shift it accordingly 
                ) != 0 ){
                    controls = true;
                     return controls;} else {return controls;}
        }
        
        function assignRole(address _user, uint32 _role) external controlledBy(msg.sender, roles[_user], true, _role) {
            require(_user != address(0) , "Invalid user address" );
            
            roles[_user] = _role;
            emit RoleAssigned(_user, _role);
        }

        function revokeRole(address _user, uint32 _role) external controlledBy(msg.sender, roles[_user], false, _role) {
            require(roles[_user] == _role, "User's role and the role to be removed don't coincide" );

            delete roles[_user];
            emit RoleRevoked(_user, _role);
        }

        function grantPermission(uint32 _role, uint8 _permissionIndex) external hasPermission(msg.sender, _permissionIndex) {
            require(canControl(roles[msg.sender], _role), "cannot grant permission, as the control relation is lacking");
            uint8 new_role_perm_value;
            new_role_perm_value  = role_permissions[_role & 31 ] | (uint8(1) << _permissionIndex);
            role_permissions[_role & 31 ] = new_role_perm_value;
            
            emit PermissionGranted(_role, _permissionIndex);
        }

        function revokePermission(uint32 _role, uint8  _permissionIndex) external hasPermission(msg.sender, _permissionIndex) {
            require(canControl(roles[msg.sender], _role), "cannot revoke permission, as the control relation is lacking");
            uint8 new_role_perm_value;
            new_role_perm_value = role_permissions[_role & 31] & ~(uint8(1) << _permissionIndex);
            role_permissions[_role & 31] = new_role_perm_value;

            emit PermissionRevoked(_role, _permissionIndex);
        }

        function hasRole(address user) external view returns(uint32) {
            return roles[user];
        }

        function has_permission(address user, uint8 _permissionIndex) external view returns (bool) {
            if (role_permissions[uint8(roles[user] & 31)] & (uint8(1) << _permissionIndex) != 0){ 
                return true;
            }else{
                return false;
            }
        }
             
         

        function Permission1() external hasPermission(msg.sender, 0) {
            // TODO: Implement the function logic here
        }
                

        function Permission2() external hasPermission(msg.sender, 1) {
            // TODO: Implement the function logic here
        }
                

        function Permission3() external hasPermission(msg.sender, 2) {
            // TODO: Implement the function logic here
        }
                

        function Permission4() external hasPermission(msg.sender, 3) {
            // TODO: Implement the function logic here
        }
                

        function Permission6() external hasPermission(msg.sender, 4) {
            // TODO: Implement the function logic here
        }
                

        function Permission5() external hasPermission(msg.sender, 5) {
            // TODO: Implement the function logic here
        }
                
}
