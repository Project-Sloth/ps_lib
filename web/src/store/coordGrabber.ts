import { writable } from 'svelte/store';

export const isCoordGrabbing = writable(false);
export const coordGrabberCoords = writable({});