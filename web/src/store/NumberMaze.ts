import { writable } from 'svelte/store';

export const numActive = writable(false);
export const numSettings = writable<any>([]);