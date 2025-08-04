import { SECURITY_CONFIG, containsForbiddenContent } from "./security";

/**
 * NUI (Native User Interface) security utilities for FiveM
 */

/**
 * Validates incoming NUI message data
 */
export function validateNuiMessage(data: any): {
	isValid: boolean;
	sanitized: any;
	message?: string;
} {
	if (data === null || data === undefined) {
		return { isValid: true, sanitized: data };
	}

	// Check if data is an object
	if (typeof data === "object") {
		try {
			// Check serialization size
			const serialized = JSON.stringify(data);
			if (serialized.length > SECURITY_CONFIG.MAX_DATA_SIZE) {
				return {
					isValid: false,
					sanitized: {},
					// Generic message - don't reveal size limits
					message: "Invalid data",
				};
			}

			// Check for suspicious content
			if (containsForbiddenContent(serialized)) {
				return {
					isValid: false,
					sanitized: {},
					// Generic message - don't reveal what patterns we check
					message: "Invalid data",
				};
			}

			return { isValid: true, sanitized: data };
		} catch (error) {
			return {
				isValid: false,
				sanitized: {},
				// Generic message - don't reveal serialization details
				message: "Invalid data",
			};
		}
	}

	// For primitive types, check for suspicious content
	if (typeof data === "string") {
		if (containsForbiddenContent(data)) {
			return {
				isValid: false,
				sanitized: "",
				// Generic message - don't reveal content filtering
				message: "Invalid data",
			};
		}
	}

	return { isValid: true, sanitized: data };
}

/**
 * Validates NUI event action names against the whitelist of allowed events
 */
export function validateNuiAction<T extends string>(action: T) {
	if (!action || typeof action !== "string") {
		return false;
	}

	if (containsForbiddenContent(action)) {
		return false;
	}

	return true;
}

/**
 * Secure wrapper for postMessage to FiveM
 */
export function securePostMessage<T extends string>(
	action: T,
	data?: any
): void {
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
		const resourceName = GetCurrentResourceName();

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

/**
 * Rate limiting for NUI events to prevent spam
 */
class NuiRateLimit {
	private actionCounts = new Map<
		string,
		{ count: number; resetTime: number }
	>();
	private readonly maxRequestsPerMinute = 60;
	private readonly windowMs = 60000; // 1 minute

	isAllowed<T extends string>(action: T): boolean {
		const now = Date.now();
		const current = this.actionCounts.get(action);

		if (!current || now > current.resetTime) {
			// Reset or first time
			this.actionCounts.set(action, {
				count: 1,
				resetTime: now + this.windowMs,
			});
			return true;
		}

		if (current.count >= this.maxRequestsPerMinute) {
			// Silent rate limiting - don't reveal limits or action names
			return false;
		}

		current.count++;
		return true;
	}
}

export const nuiRateLimit = new NuiRateLimit();

/**
 * Check if an action is allowed without validation side effects
 * Note: This is for internal use only - doesn't reveal validation details
 */
export function isNuiActionAllowed<T extends string>(
	action: T,
	nuiEvents: T[]
): boolean {
	return nuiEvents.includes(action);
}
