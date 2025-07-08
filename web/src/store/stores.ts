import { writable } from "svelte/store";

export const visibility = writable(false);
export const notification = writable({});

export async function showNotification(data:any) {
    notification.set(data);
}
