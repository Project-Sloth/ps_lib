declare module "shared/types" {
    type CommonNotificationIcons = "fa-solid fa-check" | "fa-solid fa-check-circle" | "fa-solid fa-info" | "fa-solid fa-info-circle" | "fa-solid fa-thumbs-up" | "fa-regular fa-check-circle" | "fa-regular fa-thumbs-up" | "fa-solid fa-exclamation" | "fa-solid fa-exclamation-circle" | "fa-solid fa-exclamation-triangle" | "fa-solid fa-times" | "fa-solid fa-times-circle" | "fa-solid fa-ban" | "fa-regular fa-times-circle" | "fa-solid fa-bell" | "fa-solid fa-envelope" | "fa-solid fa-user" | "fa-solid fa-users" | "fa-solid fa-cog" | "fa-solid fa-home" | "fa-solid fa-key" | "fa-solid fa-lock" | "fa-solid fa-unlock" | "fa-solid fa-heart" | "fa-solid fa-star" | "fa-solid fa-search" | "fa-solid fa-plus" | "fa-solid fa-minus" | "fa-solid fa-edit" | "fa-solid fa-trash" | "fa-solid fa-save" | "fa-solid fa-download" | "fa-solid fa-upload" | "fa-solid fa-eye" | "fa-solid fa-eye-slash" | "fa-regular fa-bell" | "fa-regular fa-envelope" | "fa-regular fa-user" | "fa-regular fa-heart" | "fa-regular fa-star" | "fa-regular fa-eye" | "fa-regular fa-eye-slash";
    export type FontAwesomeClassName = CommonNotificationIcons | (string & {});
    export type Framework = "qbcore" | "esx" | "qbox" | "other";
    export type NotifyType = "primary" | "success" | "error";
}
declare module "shared/interfaces" {
    import { FontAwesomeClassName, NotifyType } from "shared/types";
    export interface NotificationOptions {
        text: string;
        type: NotifyType;
        icon: FontAwesomeClassName;
        duration: number;
    }
}
declare module "client/notify" {
    import { NotificationOptions } from "shared/interfaces";
    /**
     * Displays a notification message to the user via NUI.
     *
     * @param message - The main text content of the notification.
     * @param options - Optional configuration for the notification, such as type, icon, and duration.
     *   - `type`: The style or category of the notification (e.g., "primary", "success", "error"). Defaults to "primary".
     *   - `icon`: The icon class to display with the notification. Defaults to "fa-solid fa-info-circle".
     *   - `duration`: How long (in milliseconds) the notification should be visible. Defaults to 5000.
     */
    function notify(message: string, options?: Partial<NotificationOptions>): void;
    export { notify };
}
declare module "security/security" {
    /**
     * Security configuration and content validation utilities
     */
    export const SECURITY_CONFIG: {
        readonly MAX_NUI_MESSAGE_SIZE: number;
        readonly MAX_DATA_SIZE: number;
        readonly MAX_INSTANCE_NAME_LENGTH: 50;
        readonly MAX_REPORT_TITLE_LENGTH: 200;
        readonly MAX_SEARCH_QUERY_LENGTH: 100;
        readonly MAX_NOTES_LENGTH: 2000;
        readonly MAX_SERIAL_NUMBER_LENGTH: 50;
        readonly MAX_EVIDENCE_ITEMS: 20;
        readonly MAX_INVOLVED_PERSONS: 50;
        readonly MAX_TAGS_PER_REPORT: 10;
        readonly MAX_IMAGE_SIZE: number;
        readonly MAX_PERSISTENCE_SIZE: number;
    };
    /**
     * Checks if text contains forbidden characters for names/identifiers
     */
    export function containsForbiddenNameChars(text: string): boolean;
    /**
     * Checks if text contains forbidden content patterns
     */
    export function containsForbiddenContent(text: string): boolean;
    /**
     * Sanitizes text by removing or escaping dangerous content
     */
    export function sanitizeText(text: string): string;
    /**
     * Validates that a string is within acceptable length limits
     */
    export function isWithinLengthLimit(text: string, maxLength: number): boolean;
    /**
     * Truncates text to specified length while preserving word boundaries
     */
    export function truncateText(text: string, maxLength: number): string;
    /**
     * Comprehensive content validation
     */
    export function validateContent(content: string, options?: {
        maxLength?: number;
        allowEmpty?: boolean;
        checkForbiddenChars?: boolean;
        checkForbiddenContent?: boolean;
    }): {
        isValid: boolean;
        sanitized: string;
        message?: string;
    };
}
declare module "security/nuiSecurity" {
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
    };
    /**
     * Validates NUI event action names against the whitelist of allowed events
     */
    export function validateNuiAction<T extends string>(action: T): boolean;
    /**
     * Rate limiting for NUI events to prevent spam
     */
    class NuiRateLimit {
        private actionCounts;
        private readonly maxRequestsPerMinute;
        private readonly windowMs;
        isAllowed<T extends string>(action: T): boolean;
    }
    export const nuiRateLimit: NuiRateLimit;
    /**
     * Check if an action is allowed without validation side effects
     * Note: This is for internal use only - doesn't reveal validation details
     */
    export function isNuiActionAllowed<T extends string>(action: T, nuiEvents: T[]): boolean;
}
declare module "shared/envBrowser" {
    export function isEnvBrowser(): boolean;
}
declare module "client/nui/fetchNui" {
    /**
     * Sends a NUI (Native UI) event to the backend and returns the response as a Promise.
     *
     * @template T - The expected response type.
     * @param eventName - The name of the NUI event to trigger.
     * @param data - Optional data to send with the event.
     * @param mockData - Optional mock data to return in browser environments for testing.
     */
    function fetchNui<T = unknown>(eventName: string, data?: unknown, mockData?: T): Promise<T>;
    export { fetchNui };
}
declare module "client/nui/sendNui" {
    /**
     * Sends a NUI (Native UI) message to the specified action endpoint with optional data.
     *
     * @param action - The action endpoint to send the message to. Must pass whitelist validation.
     * @param data - Optional data payload to send. Must pass data validation.
     */
    export function sendNui<T extends string>(action: T, data?: unknown): void;
}
declare module "client/index" {
    import { notify } from "client/notify";
    import { fetchNui } from "client/nui/fetchNui";
    import { sendNui } from "client/nui/sendNui";
    export interface PSClient {
        notify: typeof notify;
    }
    export const client: {
        fetchNui: typeof fetchNui;
        sendNui: typeof sendNui;
    };
    /**
     * Provides UI-related utilities and functions.
     *
     * @property notify - Function to trigger user notifications.
     */
    export const ui: {
        notify: typeof notify;
    };
}
declare module "security/index" {
    import { containsForbiddenContent, containsForbiddenNameChars, sanitizeText } from "security/security";
    export const security: {
        containsForbiddenContent: typeof containsForbiddenContent;
        containsForbiddenNameChars: typeof containsForbiddenNameChars;
        sanitizeText: typeof sanitizeText;
    };
}
declare module "client/resources" {
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
    export function onResourceReady(resourceName: string, callback: () => void): void;
}
declare module "utils/detection/framework-detection" {
    /**
     * Detects and returns the current framework being used based on the state of known resources.
     */
    function getFramework(): "qbcore" | "esx" | "qbox" | "other";
    export { getFramework };
}
declare module "utils/index" {
    import { onResourceReady } from "client/resources";
    import { getFramework } from "utils/detection/framework-detection";
    export interface PSUtils {
        onResourceReady: (resourceName: string, callback: () => void) => void;
    }
    export const utils: {
        onResourceReady: typeof onResourceReady;
        getFramework: typeof getFramework;
    };
}
declare module "index" {
    import { ui } from "client/index";
    import { client } from "client/index";
    import { security } from "security/index";
    import { utils } from "utils/index";
    export * from "client/index";
    export * from "utils/index";
    export interface PSLib {
        client: typeof client;
        utils: typeof utils;
        security: typeof security;
        ui: typeof ui;
    }
    global {
        interface CitizenExports {
            ["ps_lib"]: PSLib;
        }
    }
}
