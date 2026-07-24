// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;                 // 2. Compiler version this code is written for

contract InternshipProgressTracker { 
    // errors
    error onlyAdminHaveAcces();   
    error student_not_exist();
    error updateValidTAsk_value();
    error alreadyInCourse();

    // Events
     event InternRegistered(
        address indexed internAddress,
        string name,
        string course,
        uint8 age,
        bool isRemote
    );
    event InternDeactivated(
        address indexed internAddress
        // uint8 tasksCompletedAtDeactivation
    );
    
    address owner_deployer;
    
    struct Student{
        uint8 completedTasks;
        uint8 age;
        bool active_status;
        bool isRemoteWork;
        bool permenent_block;
        string courseName;
        string name;
    }

    mapping (address => Student) studentAddress;

    modifier OnlyAdmin(address _addr){
        address payable admin = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        if(msg.sender != admin) revert onlyAdminHaveAcces();
        _;
    }
    modifier CheckStudent(){
        if(!studentAddress[msg.sender].active_status) revert student_not_exist();
        _;
    }

    constructor() {
        owner_deployer = msg.sender;
    }

    function getMeInternee(address _addr,uint8 _age, bool _isremote, string memory _course ,string memory _name) public {
        // if(studentAddress[msg.sender].courseName != _course) revert alreadyInCourse();
            uint8 _cTasks = 0;
            bool _isActive = true;
            bool _permenent_block=false;

        if(!studentAddress[msg.sender].active_status){
            studentAddress[_addr] = Student(_cTasks,_age, _isActive, _permenent_block,_isremote, _course,_name); // still geting from student his adress badd main msg.sender se fetch kr lain ge 
        }else if(studentAddress[_addr].permenent_block ){ // to active him in another course
            studentAddress[_addr] = Student(_cTasks,_age, _isActive,_permenent_block, _isremote, _course,_name); 
        }
        // Emit the registration event
        emit InternRegistered(msg.sender, _name, _course, _age, _isremote);
    }

    function upDateYOURcompletedTASKS(uint8 _cTask) public {
        if(_cTask < 10)
        studentAddress[msg.sender].completedTasks = _cTask;
        else 
         revert updateValidTAsk_value();
    }

    function upDateYOURinfo(uint8 _age, bool _isremote, string memory _name) public CheckStudent() {
        Student storage stud = studentAddress[msg.sender];
        stud.age = _age;
        stud.isRemoteWork = _isremote;
        stud.name = _name;
    }

    // this can be used for deactivating from company the intern and also to active just permenent_block = false
    function toDeactive(address _addr, bool _permenent_block) external OnlyAdmin(msg.sender) {
        if(studentAddress[_addr].active_status){
            studentAddress[_addr].active_status = false;
            studentAddress[_addr].permenent_block = _permenent_block;
        }
        emit InternDeactivated(_addr);
    }

    // retrive all student data 
    function getDataRecord() external view CheckStudent() returns (address _addr, uint8 _compeletedTasks, bool _isActive, string memory _name){
        _addr = msg.sender;
        _compeletedTasks = studentAddress[msg.sender].completedTasks;
        _isActive = studentAddress[msg.sender].active_status;
        _name = studentAddress[msg.sender].name;
    }

    
}