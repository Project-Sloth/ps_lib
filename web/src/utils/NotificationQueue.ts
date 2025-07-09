import { notifications } from '../store/notificationsStore';

let currentId = 0;

export function pushNotification(notificationData: Omit<Notification, 'id'>) {
  const id = ++currentId;
  const newNotification = { ...notificationData, id };

  notifications.update((list) => [...list, newNotification]);

  if (notificationData.duration !== 0) {
    setTimeout(() => {
      removeNotification(id);
    }, notificationData.duration || 5000);
  }
}

export function removeNotification(id: number) {
  notifications.update((list) => list.filter((n) => n.id !== id));
}