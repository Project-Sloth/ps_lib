import { notify } from "./notify";
import { fetchNui } from "./nui/fetchNui";
import { sendNui } from "./nui/sendNui";
export interface PSClient {
	notify: typeof notify;
}

export const client = {
	fetchNui,
	sendNui,
};

/**
 * Provides UI-related utilities and functions.
 *
 * @property notify - Function to trigger user notifications.
 */
export const ui = {
	notify,
};
