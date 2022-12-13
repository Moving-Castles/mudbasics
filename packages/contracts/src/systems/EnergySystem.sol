// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { entityType } from "../constants.sol";

import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../components/ResourceComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "../components/CoolDownComponent.sol";
import { StatsComponent, ID as StatsComponentID, Stats } from "../components/StatsComponent.sol";
import { EntityTypeComponent, ID as EntityTypeComponentID } from "../components/EntityTypeComponent.sol";

uint256 constant ID = uint256(keccak256("system.Energy"));
int32 constant COOLDOWN_PER_RESOURCE = 3;

contract EnergySystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function updateStats(uint256 entity, uint32 resourceInput) private {
    StatsComponent statsComponent = StatsComponent(getAddressById(components, StatsComponentID));
    Stats memory currentStats = statsComponent.getValue(entity);
    currentStats.eaten += resourceInput;
    statsComponent.set(entity, currentStats);
  }

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, uint32 resourceInput) = abi.decode(arguments, (uint256, uint32));

    // Initialize components
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));
    EntityTypeComponent entityTypeComponent = EntityTypeComponent(getAddressById(components, EntityTypeComponentID));

    // Require input to be positive
    require(resourceInput > 0, "input must be positive");

    // Require entity to be a player
    require(entityTypeComponent.getValue(entity) == uint32(entityType.Player), "only (a living) player can eat.");

    // Require cooldown period to be over
    require(coolDownComponent.getValue(entity) < block.number, "in cooldown period");

    // Require the player to have enough resource
    uint32 currentResourceBalance = resourceComponent.getValue(entity);
    require(currentResourceBalance >= resourceInput, "not enough resources");

    uint32 currentEnergyLevel = energyComponent.getValue(entity);

    // 1 resource => 5 energy
    resourceComponent.set(entity, currentResourceBalance - resourceInput);
    energyComponent.set(entity, currentEnergyLevel + resourceInput * 5);

    // Add 10 cooldown points
    coolDownComponent.set(entity, block.number + 10);

    updateStats(entity, resourceInput);
  }

  function executeTyped(uint256 entity, uint32 resourceInput) public returns (bytes memory) {
    return execute(abi.encode(entity, resourceInput));
  }
}
