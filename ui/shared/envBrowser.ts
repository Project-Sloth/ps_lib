export function isEnvBrowser(): boolean {
	return typeof window !== "undefined" && typeof document !== "undefined";
}
