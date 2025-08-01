import { derived, writable, type Writable } from 'svelte/store';

export type NotificationType = 'success' | 'error' | 'warning' | 'info';

export interface Notification {
  id: number;
  message: string;
  type: NotificationType;
  duration?: number;
}

export const notifications: Writable<Notification[]> = writable([]);

export const showNotification = derived(notifications, ($notifications) => $notifications.length > 0);