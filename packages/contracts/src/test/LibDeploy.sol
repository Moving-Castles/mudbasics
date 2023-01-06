// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// NOTE: This file is autogenerated via `mud codegen-libdeploy` from `deploy.json`. Do not edit manually.

// Foundry
import { DSTest } from "ds-test/test.sol";
import { console } from "forge-std/console.sol";

// Solecs
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { World } from "solecs/World.sol";
import { IComponent } from "solecs/interfaces/IComponent.sol";
import { getAddressById } from "solecs/utils.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { ISystem } from "solecs/interfaces/ISystem.sol";

// Components (requires 'components=...' remapping in project's remappings.txt)
import { PositionComponent, ID as PositionComponentID } from "components/PositionComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "components/EnergyComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "components/ResourceComponent.sol";
import { EntityCategoryComponent, ID as EntityCategoryComponentID } from "components/EntityCategoryComponent.sol";
import { SeedComponent, ID as SeedComponentID } from "components/SeedComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "components/CoolDownComponent.sol";
import { CreatorComponent, ID as CreatorComponentID } from "components/CreatorComponent.sol";
import { StatsComponent, ID as StatsComponentID } from "components/StatsComponent.sol";
import { BirthComponent, ID as BirthComponentID } from "components/BirthComponent.sol";
import { CannibalComponent, ID as CannibalComponentID } from "components/CannibalComponent.sol";
import { PlayingComponent, ID as PlayingComponentID } from "components/PlayingComponent.sol";
import { DeathComponent, ID as DeathComponentID } from "components/DeathComponent.sol";

// Systems (requires 'systems=...' remapping in project's remappings.txt)
import { ComponentDevSystem, ID as ComponentDevSystemID } from "systems/ComponentDevSystem.sol";
import { MoveSystem, ID as MoveSystemID } from "systems/MoveSystem.sol";
import { EnergySystem, ID as EnergySystemID } from "systems/EnergySystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "systems/SpawnSystem.sol";
import { GatherSystem, ID as GatherSystemID } from "systems/GatherSystem.sol";
import { FireSystem, ID as FireSystemID } from "systems/FireSystem.sol";
import { PlaySystem, ID as PlaySystemID } from "systems/PlaySystem.sol";

struct DeployResult {
  IWorld world;
  address deployer;
}

library LibDeploy {
  function deploy(
    address _deployer,
    address _world,
    bool _reuseComponents
  ) internal returns (DeployResult memory result) {
    result.deployer = _deployer;

    // ------------------------
    // Deploy
    // ------------------------

    // Deploy world
    result.world = _world == address(0) ? new World() : IWorld(_world);
    if (_world == address(0)) result.world.init(); // Init if it's a fresh world

    // Deploy components
    if (!_reuseComponents) {
      IComponent comp;

      console.log("Deploying PositionComponent");
      comp = new PositionComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying EnergyComponent");
      comp = new EnergyComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying ResourceComponent");
      comp = new ResourceComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying EntityCategoryComponent");
      comp = new EntityCategoryComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying SeedComponent");
      comp = new SeedComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying CoolDownComponent");
      comp = new CoolDownComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying CreatorComponent");
      comp = new CreatorComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying StatsComponent");
      comp = new StatsComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying BirthComponent");
      comp = new BirthComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying CannibalComponent");
      comp = new CannibalComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying PlayingComponent");
      comp = new PlayingComponent(address(result.world));
      console.log(address(comp));

      console.log("Deploying DeathComponent");
      comp = new DeathComponent(address(result.world));
      console.log(address(comp));
    }

    // Deploy systems
    deploySystems(address(result.world), true);
  }

  function authorizeWriter(IUint256Component components, uint256 componentId, address writer) internal {
    IComponent(getAddressById(components, componentId)).authorizeWriter(writer);
  }

  /**
   * Deploy systems to the given world.
   * If `init` flag is set, systems with `initialize` setting in `deploy.json` will be executed.
   */
  function deploySystems(address _world, bool init) internal {
    IWorld world = IWorld(_world);
    // Deploy systems
    ISystem system;
    IUint256Component components = world.components();

    console.log("Deploying ComponentDevSystem");
    system = new ComponentDevSystem(world, address(components));
    world.registerSystem(address(system), ComponentDevSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, SeedComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, CreatorComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, BirthComponentID, address(system));
    authorizeWriter(components, CannibalComponentID, address(system));
    authorizeWriter(components, PlayingComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying MoveSystem");
    system = new MoveSystem(world, address(components));
    world.registerSystem(address(system), MoveSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying EnergySystem");
    system = new EnergySystem(world, address(components));
    world.registerSystem(address(system), EnergySystemID);
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying SpawnSystem");
    system = new SpawnSystem(world, address(components));
    world.registerSystem(address(system), SpawnSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, SeedComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, BirthComponentID, address(system));
    authorizeWriter(components, CannibalComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying GatherSystem");
    system = new GatherSystem(world, address(components));
    world.registerSystem(address(system), GatherSystemID);
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, CannibalComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying FireSystem");
    system = new FireSystem(world, address(components));
    world.registerSystem(address(system), FireSystemID);
    authorizeWriter(components, SeedComponentID, address(system));
    authorizeWriter(components, PositionComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, CreatorComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));

    console.log("Deploying PlaySystem");
    system = new PlaySystem(world, address(components));
    world.registerSystem(address(system), PlaySystemID);
    authorizeWriter(components, EnergyComponentID, address(system));
    authorizeWriter(components, CoolDownComponentID, address(system));
    authorizeWriter(components, EntityCategoryComponentID, address(system));
    authorizeWriter(components, PlayingComponentID, address(system));
    authorizeWriter(components, StatsComponentID, address(system));
    authorizeWriter(components, ResourceComponentID, address(system));
    authorizeWriter(components, DeathComponentID, address(system));
    console.log(address(system));
  }
}
