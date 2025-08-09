import {
	validateNuiAction,
	validateNuiMessage,
} from "../../security/nuiSecurity";

/**
 * Sends a NUI (Native UI) message to the specified action endpoint with optional data.
 *
 * @param action - The action endpoint to send the message to. Must pass whitelist validation.
 * @param data - Optional data payload to send. Must pass data validation.
 */
export function sendNui<T extends string>(action: T, data: unknown): void {
	// Validate action against whitelist (silent validation)
	if (!validateNuiAction(action)) {
		// Silent rejection - no error details
		return;
	}

	// Validate data (silent validation)
	const validation = validateNuiMessage(data);
	if (!validation.isValid) {
		// Silent rejection - no error details
		return;
	}

	// Safe to send
	try {
		const resourceName = GetInvokingResource() || GetCurrentResourceName();

		fetch(`https://${resourceName}/${action}`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify(validation.sanitized),
		});
	} catch (error) {
		// Silent failure - don't reveal fetch details
	}
}
