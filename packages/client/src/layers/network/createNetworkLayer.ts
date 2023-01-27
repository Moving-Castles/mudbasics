import type { SystemTypes } from "contracts/types/SystemTypes";
import type { GameConfig } from "./config";
import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import { createActionSystem, setupMUDNetwork } from "@latticexyz/std-client";
import { createFaucetService } from "@latticexyz/network";
import {
  defineLoadingStateComponent,
  defineCreationBlockComponent,
  defineEnergyComponent,
  defineExpirationBlockComponent,
  defineMatterComponent,
  definePortableComponent,
  definePositionComponent,
  defineReadyBlockComponent,
  defineCarryingCapacityComponent,
  defineCarriedByComponent,
  defineCoreComponent,
  defineAbilityMoveComponent,
  defineAbilityConsumeComponent,
  defineAbilityExtractComponent,
  defineGameConfigComponent,
  defineUntraversableComponent,
} from "./components";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { getNetworkConfig } from "./config";
import { utils } from "ethers";
import type { Coord } from "@latticexyz/utils";

/**
 * The Network layer is the lowest layer in the client architecture.
 * Its purpose is to synchronize the client components with the contract components.
 */
export async function createNetworkLayer(config: GameConfig) {
  console.log("Network config", config);

  // --- WORLD ----------------------------------------------------------------------
  const world = createWorld();

  // --- COMPONENTS -----------------------------------------------------------------
  const components = {
    LoadingState: defineLoadingStateComponent(world),
    GameConfig: defineGameConfigComponent(world),
    Position: definePositionComponent(world),
    Energy: defineEnergyComponent(world),
    Matter: defineMatterComponent(world),
    CreationBlock: defineCreationBlockComponent(world),
    ExpirationBlock: defineExpirationBlockComponent(world),
    ReadyBlock: defineReadyBlockComponent(world),
    Portable: definePortableComponent(world),
    CarryingCapacity: defineCarryingCapacityComponent(world),
    CarriedBy: defineCarriedByComponent(world),
    Core: defineCoreComponent(world),
    AbilityMove: defineAbilityMoveComponent(world),
    AbilityConsume: defineAbilityConsumeComponent(world),
    AbilityExtract: defineAbilityExtractComponent(world),
    Untraversable: defineUntraversableComponent(world),
  };

  // --- SETUP ----------------------------------------------------------------------
  const { txQueue, systems, txReduced$, network, startSync, encoders } = await setupMUDNetwork<
    typeof components,
    SystemTypes
  >(getNetworkConfig(config), world, components, SystemAbis);

  // Faucet setup
  const faucet = config.faucetServiceUrl ? createFaucetService(config.faucetServiceUrl) : undefined;
  const address = network.connectedAddress.get();
  console.log("player address:", address);

  // async function requestDrip() {
  //   const playerIsBroke = (await network.signer.get()?.getBalance())?.lte(utils.parseEther("0.05"));
  //   if (playerIsBroke) {
  //     console.info("[Dev Faucet] Dripping funds to player");
  //     // Double drip
  //     address && (await faucet?.dripDev({ address })) && (await faucet?.dripDev({ address }));
  //   }
  // }

  // requestDrip();
  // // Request a drip every 20 seconds
  // setInterval(requestDrip, 20000);

  // --- ACTION SYSTEM --------------------------------------------------------------
  const actions = createActionSystem(world, txReduced$);

  // --- API ------------------------------------------------------------------------
  function spawn() {
    systems["system.Spawn"].executeTyped();
  }

  function move(direction: number) {
    return systems["system.Move"].executeTyped(direction);
  }

  function extract(extractionCoordinates: Coord) {
    return systems["system.Extract"].executeTyped(extractionCoordinates);
  }

  function pickUp(portableEntity: string) {
    return systems["system.PickUp"].executeTyped(portableEntity);
  }

  function drop(portableEntity: string) {
    return systems["system.Drop"].executeTyped(portableEntity);
  }

  function take(portableEntity: string) {
    return systems["system.Take"].executeTyped(portableEntity);
  }

  function give(portableEntity: string, targetBaseEntity: string) {
    return systems["system.Give"].executeTyped(portableEntity, targetBaseEntity);
  }

  function consume(substanceBlockEntity: string) {
    return systems["system.Consume"].executeTyped(substanceBlockEntity);
  }

  // --- CONTEXT --------------------------------------------------------------------
  const context = {
    world,
    components,
    txQueue,
    systems,
    txReduced$,
    startSync,
    network,
    actions,
    api: { spawn, move, extract, pickUp, drop, take, give, consume },
    dev: setupDevSystems(world, encoders, systems),
  };

  return context;
}
