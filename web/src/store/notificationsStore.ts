import { derived, writable, type Writable } from 'svelte/store';

export type NotificationType = 'success' | 'error' | 'warning' | 'info';

export interface Notification {
  id: number;
  message: string;
  type: NotificationType;
  duration?: number;
}

// Use an array to hold multiple notifications
export const notifications: Writable<Notification[]> = writable([]);

// Optional: Derived store if you still want `showNotification`
export const showNotification = derived(notifications, ($notifications) => $notifications.length > 0);