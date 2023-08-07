// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

/// @notice Struct for StateQuery request information.
/// @dev Setting these corresponse to the `CallMsg` fields of StateQuery:
///      https://github.com/ethereum/go-ethereum/blob/fd5d2ef0a6d9eac7542ead4bfbc9b5f0f399eb10/interfaces.go#L134
/// @param chainId The chain ID of the chain where the StateQuery will be made.
/// @param blockNumber The block number of the chain where the StateQuery is made.
/// @param fromAddress The address that is used as the 'from' StateQuery argument
///        (influencing msg.sender & tx.origin). If set to address(0) then the
///        call is made from address(0).
/// @param toAddress The address that is used as the 'to' StateQuery argument.
/// @param toCalldata The calldata that is used as the 'data' StateQuery argument.
struct StateQuery {
  uint32 chainId;
  uint64 blockNumber;
  address fromAddress;
  address toAddress;
  bytes toCalldata;
}

/// @notice Struct for StateQuery request information wrapped with the attested result.
/// @param result The result from executing the StateQuery.
struct StateQueryResponse {
  uint32 chainId;
  uint64 blockNumber;
  address fromAddress;
  address toAddress;
  bytes toCalldata;
  bytes result;
}

interface IStateQueryGateway {
  function nonce() external view returns (uint256);

  function requestStateQuery(
    uint32 chainId,
    uint64 blockNumber,
    address fromAddress,
    address toAddress,
    bytes memory toCalldata,
    bytes4 callbackSelector,
    bytes memory callbackExtraData
  ) external returns (bytes32, uint256);

  function requestStateQuery(
    StateQuery memory stateQuery,
    bytes4 callbackSelector,
    bytes memory callbackExtraData
  ) external returns (bytes32, uint256);

  function requestBatchStateQuery(
    StateQuery[] memory _stateQueries,
    bytes4 _callbackSelector,
    bytes calldata _callbackExtraData
  ) external returns (bytes32, uint256);

  function currentResponse() external view returns (StateQueryResponse memory);
}
