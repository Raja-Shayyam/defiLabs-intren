// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  

contract RegisterBYowner {
    // errors
    error Admin_owner_can_Add_YOU();
    error Already_exist_this_interne();

    address Owner;
    uint8 Dailytasks;

    struct Intern{
        uint8 age;
        uint8 completed_tasks;
        bool active_status;
        bool isRemoteWork;
        bool permenent_block;
        string courseName;
        string name;
    }
    mapping (address => Intern) studentAddress;


    // modifiers
    modifier AdminAccess(){
        if(msg.sender != Owner) revert Admin_owner_can_Add_YOU();
        _;
    }
    modifier isAlreadyExist(address adr){
        if(studentAddress[adr].active_status ) revert Already_exist_this_interne();
        _;
    }

    constructor() {
        Owner = msg.sender;
    }


    function registerIntern(address _addr, uint8 _age, uint8 _cTask, bool _isRemote, string calldata _cName, string calldata _name) external AdminAccess() {
        // if(_age <18 || bytes(_cName).length>0 || !_name)
        require(_age >= 18, "Must be 18 or older");
        require(bytes(_cName).length > 0, "course name required");
        require(bytes(_name).length > 0, "Name of internee required");
        studentAddress[_addr] = Intern(_age, _cTask, true, _isRemote, false, _cName, _name);
        
    }
    function updateTask(address adr) external {
        studentAddress[adr].completed_tasks ++;
    }

    function getDataRecord() external view isAlreadyExist(_addr) returns (
        address _addr, uint8 _age, uint8 _cTask, bool _isRemote,
        string memory _cName, string memory _name
        ){
            Intern storage intrn = studentAddress[_addr];
            _age = intrn.age;
            _cTask = intrn.completed_tasks;
            _isRemote = intrn.isRemoteWork;
            _cName = intrn.courseName;
            _name = intrn.name;
        }
    
}