
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "forge-std/console.sol";

import "../src/GetPancakeV3PoolDataBatchRequest.sol";
import {GetUniswapV3TickDataBatchRequestBidirectional} from "../src/GetUniswapV3TickDataBatchRequestBidirectional.sol";
import "../src/GetUniswapV2PairsBatchRequest.sol";
// import {IPancakeV3Pool} from "../src/SyncPancakeV3PoolBatchRequest.sol";

// interface IUniswapV2Factory {
//     // length
//         function allPairsLength() external view returns (uint);
// }

interface IUniswapV3Pool {
    function tickSpacing() external view returns (int24);
    function liquidity() external view returns (uint128);
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint32 feeProtocol, bool unlocked);
    function ticks(int24 tick)
    external
    view
    returns (
        uint128 liquidityGross,
        int128 liquidityNet,
        uint256 feeGrowthOutside0X128,
        uint256 feeGrowthOutside1X128,
        int56 tickCumulativeOutside,
        uint160 secondsPerLiquidityOutsideX128,
        uint32 secondsOutside,
        bool initialized
    );
}

struct TickInfo {
        // the total position liquidity that references this tick
        uint128 liquidityGross;
        // amount of net liquidity added (subtracted) when tick is crossed from left to right (right to left),
        int128 liquidityNet;
        // fee growth per unit of liquidity on the _other_ side of this tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint256 feeGrowthOutside0X128;
        uint256 feeGrowthOutside1X128;
        // the cumulative tick value on the other side of the tick
        int56 tickCumulativeOutside;
        // the seconds per unit of liquidity on the _other_ side of this tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint160 secondsPerLiquidityOutsideX128;
        // the seconds spent on the other side of the tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint32 secondsOutside;
        // true iff the tick is initialized, i.e. the value is exactly equivalent to the expression liquidityGross != 0
        // these 8 bits are set to prevent fresh sstores when crossing newly initialized ticks
        bool initialized;
    }

contract GetPoolDataBatchRequestTest is Test {

    function testGetDataBatchRequest() public {
        // uint256 from = 1752935;
        // uint256 step = 1;
        // address factory = address(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);
        // GetUniswapV2PairsBatchRequest data = new GetUniswapV2PairsBatchRequest(from, step, factory);

        // bytes32 tx = 0x34b1e21ec4c0a822e049e98462566073cc4005401a026c622583f55e02b04396;
        // vm.createSelectFork("/tmp/reth.ipc", 46490869);

        address pool = 0x6c814E2C788D6357FC41bFD63e999a251404276e;
        IUniswapV3Pool poolContract = IUniswapV3Pool(pool);
        int24 tickSpacing = poolContract.tickSpacing();
        int24 tick;
        {
        // liquidity
        uint128 liquidity = poolContract.liquidity();
        console.log("liquidity", uint256(liquidity));
        (uint160 sqrtPriceX96, int24 tickResult, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint32 feeProtocol, bool unlocked) = poolContract.slot0();
        tick = tickResult;
        console.log("tick");
        console.logInt(tick);
        }

        (uint128 liquidityGross, int128 liquidityNet, uint256 feeGrowthOutside0X128, uint256 feeGrowthOutside1X128, int56 tickCumulativeOutside, uint160 secondsPerLiquidityOutsideX128, uint32 secondsOutside, bool initialized) = poolContract.ticks(-70800);
        console.log("liquidityGross", uint256(liquidityGross));
        console.log("liquidityNet");
        console.logInt(liquidityNet);
        console.log("Initialized");
        console.logBool(initialized);


        int24 currentTick = -74188;
        uint16 numTicksInEachDirection = 20;
        // int24 tickSpacing = 10;
        GetUniswapV3TickDataBatchRequestBidirectional c = new GetUniswapV3TickDataBatchRequestBidirectional(pool, currentTick, numTicksInEachDirection, tickSpacing);

        // GetUniswapV3PoolDataBatchRequest data = new GetUniswapV3PoolDataBatchRequest(pools);
    }
}