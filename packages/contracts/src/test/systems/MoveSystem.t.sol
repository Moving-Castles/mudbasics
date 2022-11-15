// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../../components/PositionComponent.sol";

contract MoveSystemTest is MudTest {
  function testExecute() public {
    uint256 entity = 1;
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);
    PositionComponent positionComponent = PositionComponent(component(PositionComponentID));
    MoveSystem(system(MoveSystemID)).executeTyped(entity, 3);
    Coord memory newPosition = positionComponent.getValue(entity);
    // X between 1 and 30
    assertGt(newPosition.x, 2500);
    assertLt(newPosition.x, 5000);
    // Y between 1 and 30
    assertGt(newPosition.y, 2500);
    assertLt(newPosition.y, 5000);
  }
}