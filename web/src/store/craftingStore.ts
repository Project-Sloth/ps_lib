import { writable } from 'svelte/store';

export const craftingShown = writable(false);
export const craftingRecipes = writable([]);