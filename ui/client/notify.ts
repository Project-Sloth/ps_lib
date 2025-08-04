import { NotificationOptions } from "../shared/interfaces";

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
