// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

interface IFeeVault {
  function depositNative(address _account) external payable;
  function deposit(address _account, address _token, uint256 _amount) external;
}
