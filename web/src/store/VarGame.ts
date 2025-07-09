import { writable } from 'svelte/store';

export const varActive = writable(false);
export const varSettings = writable<any>([]);