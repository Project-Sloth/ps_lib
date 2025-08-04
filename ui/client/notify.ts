import { NotificationOptions } from "../shared/interfaces";

/**
 * Displays a notification message to the user via NUI.
 *
 * @param message - The main text content of the notification.
 * @param options - Optional configuration for the notification, such as type, icon, and duration.
 *   - `type`: The style or category of the notification (e.g., "primary", "success", "error"). Defaults to "primary".
 *   - `icon`: The icon class to display with the notification. Defaults to "fa-solid fa-info-circle".
 *   - `duration`: How long (in milliseconds) the notification should be visible. Defaults to 5000.
 */
function notify(message: string, options?: Partial<NotificationOptions>) {
	SendNUIMessage({
		action: "notify",
		data: {
			text: message,
			type: options?.type || "primary",
			icon: options?.icon || "fa-solid fa-info-circle",
			duration: options?.duration || 5000,
		} satisfies NotificationOptions,
	});
}

export { notify };
