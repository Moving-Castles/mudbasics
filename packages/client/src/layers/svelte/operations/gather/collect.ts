import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player } from "../../stores/player";
import { directToLog, LogEntryType } from "../../stores/narrative";

export function collect() {
  if ((get(player).energy || 0) >= 50) {
    get(network).api?.gather(50);
    return true;
  } else {
    directToLog("You do not have enough energy to do this", LogEntryType.Failure);
    console.log("not enough energy");
    return false;
  }
}