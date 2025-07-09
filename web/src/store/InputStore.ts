import { writable } from 'svelte/store';

export const isInputting = writable(false);
export const inputData = writable<any>([]);
export const inputFormName = writable<string>('');