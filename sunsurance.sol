pragma solidity ^0.4.20;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract sunsurance is usingOraclize {
    address public owner;
    address[] public users;
    address[] public winners;
    uint public totalUsers = 0;
    uint public sumBets = 0;
    uint public today = 20180101;
    uint public temperatureToday = 28;
    uint public temperatureAverage = 30;

    constructor() public {
        owner = msg.sender;
    }

    //building a user structure
    struct User {
        uint amountBet;
        uint dateSelected;
    }

    mapping (address => User) public userInfo;



    function kill() public {
        if(msg.sender == owner) selfdestruct(owner);
    }

    function bet (uint date) public payable {
        userInfo[msg.sender].amountBet = msg.value;
        userInfo[msg.sender].dateSelected = date;
        // userInfo[msg.sender].locationSelected = location;
        sumBets += msg.value;
        users.push(msg.sender);
        totalUsers++;

    }

    function getTemperature () public constant returns (uint[]) {
        uint[] memory values = new uint[](3);
        values[0] = temperatureToday;
        values[1] = temperatureAverage;
        values[2] = totalUsers;
        return values;
    }

    function reset () public {
        temperatureToday = 28;
        today = 20180101;
    }


    function payUsers() public {
        uint count = 0;
        uint amountOfDate = 0;
    if(users.length > 0) {
        for (uint i = 0; i < users.length; i++) {
            address userAddress = users[i];
            if(userInfo[userAddress].dateSelected == today){
                amountOfDate += userInfo[userAddress].amountBet;
                if (temperatureToday < temperatureAverage) {
                    winners.push(userAddress);
                    count++;
                }
            }

          // delete userInfo[userAddress];
        }
    }
      //  users.length = 0;
        uint winnerEtherAmount = 0;
        if(count > 0 && amountOfDate > 0) {
        winnerEtherAmount = uint(amountOfDate) / uint(count);

            for(uint j = 0; j < count; j++){
                if(winners[j] != address(0)) {
                    winners[j].transfer(winnerEtherAmount);
                }
            }
        }
        today++;
        temperatureToday++;
        // delete winners;
        winners.length = 0;
    }


}
