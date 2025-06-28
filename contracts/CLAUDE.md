# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Foundry-based smart contracts workspace focused on batch data fetching utilities for various DeFi protocols, primarily Uniswap V2/V3, PancakeSwap V3, and Balancer V2. The contracts are designed as static call utilities - they're not meant to be deployed but instead used via static calls with deployment bytecode as payload.

## Common Commands

### Build
```bash
forge build
```

### Test
```bash
# Run all tests
forge test

# Run specific test file
forge test --match-path test/GetPoolDataBatchRequest.t.sol

# Run specific test with verbosity
forge test --match-test testFunctionName -vvv

# Run tests with gas reporting
forge test --gas-report
```

### Clean
```bash
forge clean
```

## Architecture

### Contract Types

1. **Batch Request Contracts** (`src/Get*.sol`): Static call utilities that fetch data from multiple pools/pairs in a single call
   - `GetUniswapV3PoolDataBatchRequest.sol`: Fetches V3 pool data including liquidity, price, ticks
   - `GetUniswapV3TickDataBatchRequest.sol`: Fetches initialized tick data from V3 pools
   - `GetUniswapV3TickDataBatchRequestBidirectional.sol`: Bidirectional tick fetching with console logging for debugging
   - `GetUniswapV2PoolDataBatchRequest.sol`: Fetches V2 pair reserves and token data
   - `GetPancakeV3PoolDataBatchRequest.sol`: PancakeSwap V3 variant
   - `GetBalancerV2PoolDataBatchRequest.sol`: Balancer V2 pool data fetching
   - `GetERC4626VaultDataBatchRequest.sol`: ERC4626 vault data fetching

2. **Sync Contracts** (`src/Sync*.sol`): Contracts for syncing pool state
   - `SyncUniswapV3PoolBatchRequest.sol`: Syncs multiple V3 pools
   - `SyncPancakeV3PoolBatchRequest.sol`: Syncs PancakeSwap V3 pools

3. **Utility Contracts**
   - `TransferFeeChecker.sol`: Checks for transfer fees on tokens
   - `GetWethValueInPoolBatchRequest.sol`: Calculates WETH value across different pool types

### Key Patterns

- All batch request contracts use constructor-based execution pattern
- Results are ABI-encoded and returned via assembly
- Contracts handle edge cases like zero balances and uninitialized ticks
- Tick data contracts respect Uniswap V3's tick boundaries (MIN_TICK: -887272, MAX_TICK: 887272)

## Development Notes

- When modifying batch request contracts, ensure the return data is properly ABI-encoded
- Test files use forge-std's Test framework
- The `GetUniswapV3TickDataBatchRequestBidirectional.sol` includes console logging - remember to remove when creating production versions
- Always check token balances before attempting to fetch pool data to avoid reverts