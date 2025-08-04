import { onResourceReady } from "../client/resources";

export interface PSUtils {
	onResourceReady: (resourceName: string, callback: () => void) => void;
}

// Export empty utils object for now - extend as needed
export const utils: PSUtils = {
	onResourceReady: onResourceReady,
};
