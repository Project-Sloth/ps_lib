import { writable } from 'svelte/store';

export const isDrawText = writable(false);
export const drawText = writable<string>('');