import { client, PSClient } from "./client";
import { PSUtils, utils } from "./utils";

export * from "./client";
export * from "./utils";

// Export individual functions for FiveM
if (typeof exports !== "undefined") {
	// Export individual functions
	Object.entries(client).forEach(([key, value]) => {
		if (typeof value === "function") {
			exports(key, value);
		}
	});

	Object.entries(utils).forEach(([key, value]) => {
		if (typeof value === "function") {
			exports(key, value);
		}
	});
}

export interface PSLib {
	client: PSClient;
	utils: PSUtils;
	// Add more utility functions here as needed
}

// Global augmentation for FiveM exports - this will be included in the generated .d.ts
declare global {
	// Extend the existing CitizenExports interface from FiveM
	interface CitizenExports {
		["ps_lib"]: PSLib;
	}
}
