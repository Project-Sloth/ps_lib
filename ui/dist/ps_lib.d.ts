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
    function notify(message: string, options?: Partial<NotificationOptions>): void;
    export { notify };
}
declare module "client/index" {
    import { notify } from "client/notify";
    export interface PSClient {
        notify: typeof notify;
    }
    export const client: PSClient;
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
declare module "utils/index" {
    export interface PSUtils {
        onResourceReady: (resourceName: string, callback: () => void) => void;
    }
    export const utils: PSUtils;
}
declare module "index" {
    import { PSClient } from "client/index";
    import { PSUtils } from "utils/index";
    export * from "client/index";
    export * from "utils/index";
    export interface PSLib {
        client: PSClient;
        utils: PSUtils;
    }
    global {
        interface CitizenExports {
            ["ps_lib"]: PSLib;
        }
    }
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
declare module "security/inputValidation" {
    /**
     * Input validation utilities using the global security config
     */
    /**
     * Validates and sanitizes tag input
     */
    export function validateTagInput(tag: string): {
        isValid: boolean;
        sanitized: string;
        message?: string;
    };
    /**
     * Validates report title input
     */
    export function validateReportTitle(title: string): {
        isValid: boolean;
        sanitized: string;
        message?: string;
    };
    /**
     * Validates search query input
     */
    export function validateSearchQuery(query: string): {
        isValid: boolean;
        sanitized: string;
        message?: string;
    };
    /**
     * Validates text area/notes input
     */
    export function validateNotesInput(notes: string): {
        isValid: boolean;
        sanitized: string;
        message?: string;
    };
    /**
     * Validates evidence serial number input
     */
    export function validateSerialNumber(serial: string): {
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
     * Secure wrapper for postMessage to FiveM
     */
    export function securePostMessage<T extends string>(action: T, data?: any): void;
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
declare module "utils/detection/framework-detection" {
    import { Framework } from "shared/types";
    function getFramework(): Framework;
    export { getFramework };
}
declare module "utils/nui/fetchNui" {
    export function fetchNui<T = any>(eventName: string, data?: any, mockData?: T): Promise<T>;
}
