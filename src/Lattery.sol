// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Lattery {
    uint256 constant PARTICIPANTS_NUM = 5;

    uint256 public gameId;
    mapping(uint256 => address[]) public players;
    mapping(uint256 => uint256) public stake;
    mapping(uint256 => address) public winner;

    function create(uint256 numPlayers) public payable {
        require(numPlayers <= PARTICIPANTS_NUM, "Too many players");
        players[gameId] = new address[](numPlayers);

        require(msg.value > 0, "Value must be greater than 0");
        stake[gameId] = msg.value;

        gameId++;
    }

    function join(uint256 _gameId) public {
        require(players[_gameId].length <= PARTICIPANTS_NUM, "Game is full");

        address[] memory _players = players[_gameId];
        for (uint256 i = 0; i < _players.length; i++) {
            if (_players[i] == address(0)) {
                players[_gameId][i] = msg.sender;
                break;
            }
        }
    }

    function getPlayers(uint256 _gameId) public view returns (address[] memory) {
        return players[_gameId];
    }

    function getPlayersLength(uint256 _gameId) public view returns (uint256) {
        return players[_gameId].length;
    }

    function select(uint256 _gameId) public {
        uint256 length = players[_gameId].length;
        require(players[_gameId][length - 1] != address(0), "Cannot be yet started");

        require(winner[_gameId] != address(0), "Winner is already selected");

        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, _gameId))) % length;
        winner[_gameId] = players[_gameId][rand];
    }

    function claim(uint256 _gameId) public payable {
        require(msg.sender == winner[_gameId], "Not the winner");

        address to = msg.sender;
        uint256 amount = stake[_gameId];
        require(amount > 0, "Amount must be greater than 0");

        (bool success, ) = to.call{value: amount}("");
        require(success, "Failed to send");
    }
}
