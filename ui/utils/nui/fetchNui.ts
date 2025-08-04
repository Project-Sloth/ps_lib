import {
	validateNuiAction,
	validateNuiMessage,
} from "../../security/nuiSecurity";
import { isEnvBrowser } from "../../shared/envBrowser";

export async function fetchNui<T = any>(
	eventName: string,
	data?: any,
	mockData?: T
): Promise<T> {
	// Security: Validate the event name (silent)
	if (!validateNuiAction(eventName)) {
		// Silent rejection - return empty promise that never resolves
		return new Promise(() => {});
	}

	// Security: Validate the data being sent (silent)
	if (data !== undefined) {
		const validation = validateNuiMessage(data);
		if (!validation.isValid) {
			// Silent rejection - return empty promise that never resolves
			return new Promise(() => {});
		}
		data = validation.sanitized;
	}

	const options = {
		method: "POST",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify(data),
	};

	if (isEnvBrowser()) {
		if (mockData) {
			return new Promise((resolve) => {
				setTimeout(() => resolve(mockData), 100);
			});
		}
		return new Promise((resolve) => {
			setTimeout(() => resolve({} as T), 100);
		});
	}

	const resourceName = GetCurrentResourceName();

	const resp = await fetch(`https://${resourceName}/${eventName}`, options);

	if (resp.ok) {
		return await resp.json();
	}

	throw new Error(`HTTP error! status: ${resp.status}`);
}
