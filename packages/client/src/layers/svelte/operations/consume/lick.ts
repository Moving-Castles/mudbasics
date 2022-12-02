import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player } from "../../stores/player";

export function lick() {
  if ((get(player).resource || 0) >= 5) {
    get(network).api?.consume(5);
    return true;
  } else {
    console.log("Lick: not enough resource");
    return false;
  }
}