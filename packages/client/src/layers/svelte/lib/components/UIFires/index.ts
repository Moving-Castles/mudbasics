import { writable, derived, get } from "svelte/store";
import { blockNumber } from "../../../modules/network";

export const fireString = (v) => {
  const valueStore = writable(v);

  return derived([valueStore, blockNumber], ([$value, $blockNumber]) => {
    let str = "";

    if (Math.max($value.coolDownBlock - $blockNumber, 0) > 0) {
      str += "🔥 ";
    } else {
      str += "🕳 ";
    }

    if ($value.coolDownBlock) {
      str += `/ burntime: ${Math.max($value.coolDownBlock - $blockNumber, 0)}`;
    }
    if ($value.resource) {
      str += ` / resources: ${$value.resource}`;
    }

    return str;
  });
};

export function fireStatusString(v) {
  if (Math.max(v.coolDownBlock - get(blockNumber), 0) > 0) {
    return "🔥";
  } else {
    return "🕳";
  }
}

export function fireStatusClass(v) {
  if (Math.max(v.coolDownBlock - get(blockNumber), 0) > 0) {
    return "fire fire-on";
  } else {
    return "fire fire-off";
  }
}
