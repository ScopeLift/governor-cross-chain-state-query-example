// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {IGovernor} from "openzeppelin/governance/IGovernor.sol";
import {IStateQueryGateway, StateQuery} from "src/interfaces/IStateQueryGateway.sol";
import {IL1Block} from "src/interfaces/IL1Block.sol";

contract L1GovernorMetadata {
  IStateQueryGateway public immutable stateQueryGateway;
  uint32 public immutable L1_CHAIN;
  IL1Block public immutable l1Block;
  address public immutable L1_GOVERNOR_ADDR;

  struct Proposal {
    uint256 voteStart;
    uint256 voteEnd;
  }

  /// @notice The id of the proposal mapped to the proposal metadata.
  mapping(uint256 => Proposal) public proposals;

  constructor(address _stateQueryGateway, uint32 _chain, address _l1Governor, address _l1Block) {
    stateQueryGateway = IStateQueryGateway(_stateQueryGateway);
    L1_CHAIN = _chain;
    L1_GOVERNOR_ADDR = _l1Governor;
    l1Block = IL1Block(_l1Block);
  }

  function requestProposalSnapshot(uint256 proposalId) internal {
    StateQuery memory stateQuery = StateQuery({
      chainId: L1_CHAIN,
      blockNumber: l1Block.number(),
      fromAddress: address(0),
      toAddress: L1_GOVERNOR_ADDR,
      toCalldata: abi.encodeWithSelector(IGovernor.proposalSnapshot.selector, proposalId)
    });
    stateQueryGateway.requestStateQuery(
      stateQuery,
      L1GovernorMetadata.storeProposalSnapshot.selector, // Which function to call after async call
        // is done
      abi.encode(proposalId) // What other data to pass to the callback
    );
  }

  function requestProposalDeadline(uint256 proposalId) internal {
    StateQuery memory stateQuery = StateQuery({
      chainId: L1_CHAIN,
      blockNumber: l1Block.number(),
      fromAddress: address(0),
      toAddress: L1_GOVERNOR_ADDR,
      toCalldata: abi.encodeWithSelector(IGovernor.proposalDeadline.selector, proposalId)
    });
    stateQueryGateway.requestStateQuery(
      stateQuery,
      L1GovernorMetadata.storeProposalDeadline.selector, // Which function to call after async call
        // is done
      abi.encode(proposalId) // What other data to pass to the callback
    );
  }

  function storeProposalSnapshot(bytes memory _requestResult, bytes memory _callbackExtraData)
    external
  {
    require(msg.sender == address(stateQueryGateway));
    uint256 voteEnd = abi.decode(_requestResult, (uint256));
    (uint256 proposalId) = abi.decode(_callbackExtraData, (uint256));

    Proposal memory proposal = proposals[proposalId];
    proposals[proposalId] = Proposal({voteStart: proposal.voteStart, voteEnd: voteEnd});
  }

  function storeProposalDeadline(bytes memory _requestResult, bytes memory _callbackExtraData)
    external
  {
    require(msg.sender == address(stateQueryGateway));
    uint256 voteStart = abi.decode(_requestResult, (uint256));
    (uint256 proposalId) = abi.decode(_callbackExtraData, (uint256));

    Proposal memory proposal = proposals[proposalId];
    proposals[proposalId] = Proposal({voteStart: voteStart, voteEnd: proposal.voteEnd});
  }

  function getL1Proposal(uint256 proposalId) public {
    Proposal memory proposal = proposals[proposalId];
    if (proposal.voteStart == 0) {
      requestProposalSnapshot(proposalId);
      requestProposalDeadline(proposalId);
      return;
    }
    return;
  }
}
