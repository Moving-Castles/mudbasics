import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player } from "../../stores/player";
import { Directions } from "../../utils/space";

export function west() {
  if ((get(player).energy || 0) >= 10) {
    get(network).api?.move(10, Directions.West);
    return true;
  } else {
    console.log("Walk: not enough energy");
    return false;
  }
}
