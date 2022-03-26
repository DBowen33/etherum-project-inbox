pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restrictedOnlyManagerCanCall {
        uint index = random() % players.length;
        players[index].transfer(this.balance /* amount of money in contact */);
        players = new address[](0);
    }

    modifier restrictedOnlyManagerCanCall() {
        require(msg.sender == manager);
        _; //takes all code out of function that is calling restricted... and runs it
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}


