/**
 * Waits for a specified resource to reach the "started" state before executing a callback.
 *
 * This function repeatedly checks the state of the given resource using `window.GetResourceState`.
 * Once the resource state is "started", the provided callback is invoked. If the resource is not
 * yet started or an error occurs during the check, the function will retry after a 1-second delay.
 *
 * @param resourceName - The name of the resource to monitor.
 * @param callback - The function to execute once the resource is ready.
 */
export function onResourceReady(
	resourceName: string,
	callback: () => void
): void {
	const checkResourceState = () => {
		try {
			const state = window.GetResourceState(resourceName);
			if (state === "started") {
				callback();
			} else {
				setTimeout(checkResourceState, 1000);
			}
		} catch (err) {
			console.error(
				`Error checking resource state for ${resourceName}:`,
				err
			);
			setTimeout(checkResourceState, 1000);
		}
	};

	checkResourceState();
}
