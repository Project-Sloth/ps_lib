import { writable } from 'svelte/store';

export const thermActive = writable(false);
export const thermSettings = writable<any>([]);