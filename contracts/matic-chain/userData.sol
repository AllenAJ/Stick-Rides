pragma solidity 0.5.2;

contract userData {
    
    struct User{
        uint score;
        string name;
    }
    
    string public testAddr ;
    mapping(address => User) userByAddress;
    User user;
    function registerUser(string memory _name)public {
        
        // User memory user = User({
        //     score: 0,
        //     name: _name
        // }) ;
        user.name = _name;
        userByAddress[msg.sender] = user;
    }
    
    function login()public view returns (uint, string memory){
        //testAddr = userByAddress[msg.sender].name;
        return (userByAddress[msg.sender].score,userByAddress[msg.sender].name);
    }
}
