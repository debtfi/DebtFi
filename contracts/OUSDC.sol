//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OUSDC is ERC20 {
    constructor() ERC20("OUSDC", "OUSDC") {
        _mint(msg.sender, 100000000000);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
