import { onResourceReady } from "../client/resources";
import { getFramework } from "./detection/framework-detection";

export interface PSUtils {
	onResourceReady: (resourceName: string, callback: () => void) => void;
}

// Export empty utils object for now - extend as needed
export const utils = {
	onResourceReady,
	getFramework,
};
