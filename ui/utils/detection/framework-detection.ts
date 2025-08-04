import { Framework } from "../../shared/types";

/**
 * Detects and returns the current framework being used based on the state of known resources.
 */
function getFramework() {
	const resourceStates: Record<Framework, string> = {
		qbcore: "qb-core",
		esx: "es_extended",
		qbox: "qbox-core",
		other: "",
	};

	if (typeof window.GetResourceState === "function") {
		for (const framework in resourceStates) {
			if (framework === "other") continue;
			const resource = resourceStates[framework as Framework];
			try {
				if (window.GetResourceState(resource) === "started") {
					return framework as "qbcore" | "esx" | "qbox" | "other";
				}
			} catch (error) {
				console.error(
					`Error checking resource state for ${resource}:`,
					error
				);
			}
		}
	}
	return "other";
}

export { getFramework };
