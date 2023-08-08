// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {L1GovernorMetadata} from "src/GovernorMetadata.sol";

contract L1MetadataTest is Test {
  address immutable NOUNS_L1_GOVERNOR = 0x6f3E6272A167e8AcCb32072d08E0957F9c79223d;
  address immutable STATE_QUERY_GATEWAY_OPTIMISM_GOERLI = 0x1b132819aFE2AFD5b76eF6721bCCC6Ede40cd9eC;
  uint32 immutable ETHEREUM_MAINNET_CHAIN_ID = 1;
  address immutable L1_BLOCK_ADDRESS = 0x4200000000000000000000000000000000000015;
  L1GovernorMetadata l1GovernorMetadata;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl("optimism_goerli"));
    L1GovernorMetadata _l1GovernorMetadata = new L1GovernorMetadata(
      STATE_QUERY_GATEWAY_OPTIMISM_GOERLI, ETHEREUM_MAINNET_CHAIN_ID, NOUNS_L1_GOVERNOR, L1_BLOCK_ADDRESS
    );
	  l1GovernorMetadata = _l1GovernorMetadata;
  }
}



contract getL1Proposal is L1MetadataTest {
  function testForkFuzz_GetL1ProposalNoProposal(uint256 proposalId) public {
	(L1GovernorMetadata.Proposal memory proposal, bool exists) =	  l1GovernorMetadata.getL1Proposal(proposalId);
	assertEq(exists, false);
	assertEq(proposal.voteStart, 0);
	assertEq(proposal.voteEnd, 0);
  }
}
