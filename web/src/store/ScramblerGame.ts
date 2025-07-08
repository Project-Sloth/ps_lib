import { writable } from 'svelte/store';

export const scramblerActive = writable(false);
export const scramblerSettings = writable({});