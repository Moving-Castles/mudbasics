import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player } from "../../stores/player";

export function nibble() {
  if ((get(player).resource || 0) >= 5) {
    get(network).api?.consume(5);
    return true;
  } else {
    console.log("Nibble: not enough resource");
    return false;
  }
}
