// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Lattery {
    uint256 constant PARTICIPANTS_NUM = 5;

    uint256 public gameId;
    mapping(uint256 => address[]) public players;
    mapping(uint256 => uint256) public stake;

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
}
