// Most common notification icons with custom string support
// This provides IntelliSense for common icons while allowing any custom string

// Common notification icons (curated list of most used in notifications)
type CommonNotificationIcons =
	// Success/Info icons
	| "fa-solid fa-check"
	| "fa-solid fa-check-circle"
	| "fa-solid fa-info"
	| "fa-solid fa-info-circle"
	| "fa-solid fa-thumbs-up"
	| "fa-regular fa-check-circle"
	| "fa-regular fa-thumbs-up"

	// Error/Warning icons
	| "fa-solid fa-exclamation"
	| "fa-solid fa-exclamation-circle"
	| "fa-solid fa-exclamation-triangle"
	| "fa-solid fa-times"
	| "fa-solid fa-times-circle"
	| "fa-solid fa-ban"
	| "fa-regular fa-times-circle"

	// General notification icons
	| "fa-solid fa-bell"
	| "fa-solid fa-envelope"
	| "fa-solid fa-user"
	| "fa-solid fa-users"
	| "fa-solid fa-cog"
	| "fa-solid fa-home"
	| "fa-solid fa-key"
	| "fa-solid fa-lock"
	| "fa-solid fa-unlock"
	| "fa-solid fa-heart"
	| "fa-solid fa-star"
	| "fa-solid fa-search"
	| "fa-solid fa-plus"
	| "fa-solid fa-minus"
	| "fa-solid fa-edit"
	| "fa-solid fa-trash"
	| "fa-solid fa-save"
	| "fa-solid fa-download"
	| "fa-solid fa-upload"
	| "fa-solid fa-eye"
	| "fa-solid fa-eye-slash"
	| "fa-regular fa-bell"
	| "fa-regular fa-envelope"
	| "fa-regular fa-user"
	| "fa-regular fa-heart"
	| "fa-regular fa-star"
	| "fa-regular fa-eye"
	| "fa-regular fa-eye-slash";

// Union type that provides IntelliSense for common icons but allows any string
export type FontAwesomeClassName = CommonNotificationIcons | (string & {});

export type Framework = "qbcore" | "esx" | "qbox" | "other";
export type NotifyType = "primary" | "success" | "error";
