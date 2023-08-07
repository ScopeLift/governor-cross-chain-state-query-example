// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Deploy} from "script/Deploy.s.sol";

contract CounterTest is Test, Deploy {
  function setUp() public {
    Deploy.run();
  }
}

contract Increment is CounterTest {
  function test_NumberIsIncremented() public {}
}

contract SetNumber is CounterTest {
  function testFuzz_NumberIsSet(uint256 x) public {}
}
