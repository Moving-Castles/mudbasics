// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../components/ResourceComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "../components/CoolDownComponent.sol";
import { StatsComponent, ID as StatsComponentID, Stats } from "../components/StatsComponent.sol";

uint256 constant ID = uint256(keccak256("system.Energy"));
int32 constant COOLDOWN_PER_RESOURCE = 3;

contract EnergySystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function updateStats(uint256 entity, int32 resourceInput) public {
    StatsComponent statsComponent = StatsComponent(getAddressById(components, StatsComponentID));
    Stats memory currentStats = statsComponent.getValue(entity);
    currentStats.eaten += resourceInput;
    statsComponent.set(entity, currentStats);
  }

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, int32 resourceInput) = abi.decode(arguments, (uint256, int32));

    // Initialize components
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));

    // Require entity to be caller
    // require(entity == addressToEntity(msg.sender), "player does not own entity");

    // Require cooldown period to be over
    require(coolDownComponent.getValue(entity) < int32(int256(block.number)), "in cooldown period");

    // Require the player to have enough resource
    int32 currentResourceBalance = resourceComponent.getValue(entity);
    require(currentResourceBalance >= resourceInput, "not enough resources");

    int32 currentEnergyLevel = energyComponent.getValue(entity);

    // 1 resource => 5 energy
    resourceComponent.set(entity, currentResourceBalance - resourceInput);
    energyComponent.set(entity, currentEnergyLevel + resourceInput * 5);

    // 3 cooldown points / resource consumed
    coolDownComponent.set(entity, int32(int256(block.number)) + (COOLDOWN_PER_RESOURCE * resourceInput));

    updateStats(entity, resourceInput);
  }

  function executeTyped(uint256 entity, int32 energyInput) public returns (bytes memory) {
    return execute(abi.encode(entity, energyInput));
  }
}
