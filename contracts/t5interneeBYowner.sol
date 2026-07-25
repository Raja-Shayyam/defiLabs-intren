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
    uint8 public totalTasks;
    mapping (address => Intern) studentAddress;
    mapping (uint8 => string) tasksBYadmin;
    mapping (address => mapping (uint8 => bool)) dailytask_complete;


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


    function registerIntern(address _addr, uint8 _age, bool _isRemote, string calldata _cName, string calldata _name) external AdminAccess() isAlreadyExist(_addr){
        // if(_age <18 || bytes(_cName).length>0 || !_name)
        require(_age >= 18, "Must be 18 or older");
        require(bytes(_cName).length > 0, "course name required");
        require(bytes(_name).length > 0, "Name of internee required");
        studentAddress[_addr] = Intern(_age, 0, true, _isRemote, false, _cName, _name);
        
    }
    function BYinterneeDalytasks(uint8 _taskINDEX) external {
        // getAllTasks();

        dailytask_complete[msg.sender][_taskINDEX] = true;
        studentAddress[msg.sender].completed_tasks++;

        // emit (msg.sender, _taskINDEX, getTaskName(_taskINDEX));
    }

    function getMyDONEtasks() external view isAlreadyExist(msg.sender) returns (string[] memory){
        string[] memory status = new string[](totalTasks);

        for(uint8 i=0; i<totalTasks; i++){
            if(dailytask_complete[msg.sender][i+1]){
                status[i] = string.concat(tasksBYadmin[i+1]," is done by me");
            }
        }
        return status;
    }

    function updateTask(uint8 _taskNo, string calldata _taskName) external AdminAccess() {
        tasksBYadmin[_taskNo] = _taskName;
        totalTasks++;
    }

    function getTaskName(uint8 _taskNumber) public view returns (string memory) {
        return tasksBYadmin[_taskNumber];
        
        // if (_taskNumber == 1) return "1. Morning Standup";
        // if (_taskNumber == 2) return "2. Code Review";
        // if (_taskNumber == 3) return "3. Solidity Practice";
        // if (_taskNumber == 4) return "4. Documentation";
        // if (_taskNumber == 5) return "5. Team Meeting";
        // if (_taskNumber == 6) return "6. Bug Fixing";
        // if (_taskNumber == 7) return "7. Learning Session";
        // if (_taskNumber == 8) return "8. Daily Report";
        
    }
    

    function deActiveIntern(address _adr) external AdminAccess(){
        studentAddress[_adr].active_status = false;
    }

    function getAllTasks() external view returns (string[] memory) {
        string[] memory allTasks = new string[](totalTasks);

        for(uint8 i=0; i<totalTasks; i++){
            allTasks[i] = tasksBYadmin[i+1];
        }

        return allTasks;
        // return [
        //     "1. Morning Standup",
        //     "2. Code Review",
        //     "3. Solidity Practice",
        //     "4. Documentation",
        //     "5. Team Meeting",
        //     "6. Bug Fixing",
        //     "7. Learning Session",
        //     "8. Daily Report"
        // ];
    }

    function getDataRecord() external view returns (
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