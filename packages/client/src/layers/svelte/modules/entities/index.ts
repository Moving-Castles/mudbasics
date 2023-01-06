import type { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import { network, blockNumber } from "../network";
import { player, calculateEnergy } from "../player";
import { uniq } from "lodash";
import { seedToName } from "../../utils/name";

// --- TYPES -----------------------------------------------------------------

export enum EntityCategory {
  Player,
  Terrain,
  Fire,
  Corpse,
  Ghost,
}

export type StatsCategory = {
  traveled: number;
  gathered: number;
  burnt: number;
  eaten: number;
};

export type Player = {
  entityCategory: EntityCategory.Player;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsCategory;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

export type Corpse = {
  entityCategory: EntityCategory.Corpse;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsCategory;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

export type Ghost = {
  entityCategory: EntityCategory.Ghost;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsCategory;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

export type Terrain = {
  entityCategory: EntityCategory.Terrain;
  position: Coord;
  resource: number;
};

export type Fire = {
  entityCategory: EntityCategory.Fire;
  position: Coord;
  coolDownBlock?: number;
  creator: string[];
  resource: number;
  seed: number;
};

export type Entity = Player | Terrain | Fire | Corpse | Ghost;

export type Players = {
  [index: string]: Player;
};

export type Terrains = {
  [index: string]: Terrain;
};

export type Fires = {
  [index: string]: Fire;
};

export type Corpses = {
  [index: string]: Corpse;
};

export type Ghosts = {
  [index: string]: Ghost;
};

export type Entities = {
  [index: string]: Entity;
};

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const players = derived([entities, blockNumber], ([$entities, $blockNumber]) => {
  let ps = Object.entries($entities).filter(
    ([k, e]) => e.entityCategory == EntityCategory.Player || e.entityCategory == EntityCategory.Corpse
  );

  // Now double check for each one if they are dead
  ps = ps.map(([k, e]) => {
    const energy = calculateEnergy(e, $blockNumber);
    if (energy < 1) {
      e.entityCategory = EntityCategory.Corpse;
    } else if (e.entityCategory == EntityCategory.Corpse && energy > 0) {
      // Looks like you respawned, Padawan...
      e.entityCategory = EntityCategory.Player;
    }
    return [k, e];
  });

  return Object.fromEntries(ps);
});

export const fires = derived(
  entities,
  ($entities) =>
    Object.fromEntries(
      Object.entries($entities).filter(([v, e]) => e.entityCategory == EntityCategory.Fire)
    ) as Entities
);

export const terrains = derived(
  entities,
  ($entities) =>
    Object.fromEntries(
      Object.entries($entities).filter(([v, e]) => e.entityCategory == EntityCategory.Terrain)
    ) as Entities
);

export const corpses = derived(
  entities,
  ($entities) =>
    Object.fromEntries(
      Object.entries($entities).filter(([v, e]) => e.entityCategory == EntityCategory.Corpse)
    ) as Entities
);

// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => {
  return get(network).world?.entities[index];
};

/**
 * Format player list
 * @param Array of player names
 * @returns formatted string of names
 */
export function playerList(players: string[]): string {
  const playerNames = players.map((p) => (get(entities)[p] ? seedToName(get(entities)[p].seed) : "not-found"));

  for (let i = 0; i < playerNames.length; i++) {
    if (playerNames[i] === seedToName(get(player).seed || 0)) {
      playerNames[i] += " (you)";
    }
  }

  // HACK: should make sure that the creator array on contract level is unique instead...
  return uniq(playerNames).join(", ");
}
