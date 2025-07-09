import { writable } from 'svelte/store';

export const contextMenuShown = writable(false);
export const contextMenuItems = writable<any>([]);