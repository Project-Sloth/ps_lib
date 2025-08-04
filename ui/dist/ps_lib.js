var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
// Most common notification icons with custom string support
// This provides IntelliSense for common icons while allowing any custom string
define("shared/types", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
});
define("shared/interfaces", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
});
define("client/notify", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.notify = notify;
    /**
     * Displays a notification message to the user via NUI.
     *
     * @param message - The main text content of the notification.
     * @param options - Optional configuration for the notification, such as type, icon, and duration.
     *   - `type`: The style or category of the notification (e.g., "primary", "success", "error"). Defaults to "primary".
     *   - `icon`: The icon class to display with the notification. Defaults to "fa-solid fa-info-circle".
     *   - `duration`: How long (in milliseconds) the notification should be visible. Defaults to 5000.
     */
    function notify(message, options) {
        SendNUIMessage({
            action: "notify",
            data: {
                text: message,
                type: options?.type || "primary",
                icon: options?.icon || "fa-solid fa-info-circle",
                duration: options?.duration || 5000,
            },
        });
    }
});
/**
 * Security configuration and content validation utilities
 */
define("security/security", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.SECURITY_CONFIG = void 0;
    exports.containsForbiddenNameChars = containsForbiddenNameChars;
    exports.containsForbiddenContent = containsForbiddenContent;
    exports.sanitizeText = sanitizeText;
    exports.isWithinLengthLimit = isWithinLengthLimit;
    exports.truncateText = truncateText;
    exports.validateContent = validateContent;
    exports.SECURITY_CONFIG = {
        MAX_NUI_MESSAGE_SIZE: 1024 * 1024, // 1MB
        MAX_DATA_SIZE: 1024 * 1024, // 1MB
        // Text length limits
        MAX_INSTANCE_NAME_LENGTH: 50,
        MAX_REPORT_TITLE_LENGTH: 200,
        MAX_SEARCH_QUERY_LENGTH: 100,
        MAX_NOTES_LENGTH: 2000,
        MAX_SERIAL_NUMBER_LENGTH: 50,
        // Content limits
        MAX_EVIDENCE_ITEMS: 20,
        MAX_INVOLVED_PERSONS: 50,
        MAX_TAGS_PER_REPORT: 10,
        // File size limits
        MAX_IMAGE_SIZE: 5 * 1024 * 1024, // 5MB
        MAX_PERSISTENCE_SIZE: 5 * 1024 * 1024, // 5MB
    };
    /**
     * List of forbidden characters for names and identifiers
     */
    const FORBIDDEN_NAME_CHARS = [
        "<",
        ">",
        '"',
        "'",
        "&",
        "\0",
        "\r",
        "\n",
        "\t",
        "script",
        "javascript:",
        "vbscript:",
        "onload",
        "onerror",
        "data:",
        "blob:",
        "file:",
        "ftp:",
        "javascript",
    ];
    /**
     * List of suspicious content patterns
     */
    const FORBIDDEN_CONTENT_PATTERNS = [
        // Script injection attempts
        /<script\b/i,
        /<\/script>/i,
        /javascript:/i,
        /vbscript:/i,
        /onload\s*=/i,
        /onerror\s*=/i,
        /onclick\s*=/i,
        /onmouseover\s*=/i,
        // HTML injection
        /<iframe\b/i,
        /<object\b/i,
        /<embed\b/i,
        /<form\b/i,
        /<input\b/i,
        // SQL injection patterns
        /union\s+select/i,
        /drop\s+table/i,
        /delete\s+from/i,
        /insert\s+into/i,
        /update\s+set/i,
        // Path traversal
        /\.\.\//,
        /\.\.[/\\]/,
        // Command injection
        /\\\|\s*[a-zA-Z]/,
        /;\s*[a-zA-Z]/,
        /&&\s*[a-zA-Z]/,
        /\$\(/,
        /`[^`]*`/,
    ];
    /**
     * Checks if text contains forbidden characters for names/identifiers
     */
    function containsForbiddenNameChars(text) {
        if (!text || typeof text !== "string") {
            return false;
        }
        const lowerText = text.toLowerCase();
        return FORBIDDEN_NAME_CHARS.some((char) => lowerText.includes(char.toLowerCase()));
    }
    /**
     * Checks if text contains forbidden content patterns
     */
    function containsForbiddenContent(text) {
        if (!text || typeof text !== "string") {
            return false;
        }
        // Check for forbidden patterns
        return FORBIDDEN_CONTENT_PATTERNS.some((pattern) => {
            if (pattern instanceof RegExp) {
                return pattern.test(text);
            }
            return false;
        });
    }
    /**
     * Sanitizes text by removing or escaping dangerous content
     */
    function sanitizeText(text) {
        if (!text || typeof text !== "string") {
            return "";
        }
        return text
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#x27;")
            .replace(/&/g, "&amp;")
            .replace(/\0/g, "")
            .replace(/\r\n/g, "\n")
            .replace(/\r/g, "\n")
            .trim();
    }
    /**
     * Validates that a string is within acceptable length limits
     */
    function isWithinLengthLimit(text, maxLength) {
        return !text || text.length <= maxLength;
    }
    /**
     * Truncates text to specified length while preserving word boundaries
     */
    function truncateText(text, maxLength) {
        if (!text || text.length <= maxLength) {
            return text || "";
        }
        const truncated = text.substring(0, maxLength);
        const lastSpace = truncated.lastIndexOf(" ");
        // If we can break at a word boundary, do so
        if (lastSpace > maxLength * 0.8) {
            return truncated.substring(0, lastSpace) + "...";
        }
        // Otherwise, hard truncate
        return truncated + "...";
    }
    /**
     * Comprehensive content validation
     */
    function validateContent(content, options = {}) {
        const { maxLength = Infinity, allowEmpty = true, checkForbiddenChars = true, checkForbiddenContent = true, } = options;
        if (!content || typeof content !== "string") {
            if (!allowEmpty) {
                return {
                    isValid: false,
                    sanitized: "",
                    message: "Content is required",
                };
            }
            return { isValid: true, sanitized: "" };
        }
        const trimmed = content.trim();
        if (!allowEmpty && trimmed.length === 0) {
            return {
                isValid: false,
                sanitized: "",
                message: "Content is required",
            };
        }
        if (!isWithinLengthLimit(trimmed, maxLength)) {
            return {
                isValid: false,
                sanitized: truncateText(trimmed, maxLength),
                message: `Content exceeds maximum length of ${maxLength} characters`,
            };
        }
        if (checkForbiddenChars && containsForbiddenNameChars(trimmed)) {
            return {
                isValid: false,
                sanitized: sanitizeText(trimmed),
                message: "Content contains forbidden characters",
            };
        }
        if (checkForbiddenContent && containsForbiddenContent(trimmed)) {
            return {
                isValid: false,
                sanitized: sanitizeText(trimmed),
                message: "Content contains suspicious patterns",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
});
define("security/nuiSecurity", ["require", "exports", "security/security"], function (require, exports, security_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.nuiRateLimit = void 0;
    exports.validateNuiMessage = validateNuiMessage;
    exports.validateNuiAction = validateNuiAction;
    exports.isNuiActionAllowed = isNuiActionAllowed;
    /**
     * NUI (Native User Interface) security utilities for FiveM
     */
    /**
     * Validates incoming NUI message data
     */
    function validateNuiMessage(data) {
        if (data === null || data === undefined) {
            return { isValid: true, sanitized: data };
        }
        // Check if data is an object
        if (typeof data === "object") {
            try {
                // Check serialization size
                const serialized = JSON.stringify(data);
                if (serialized.length > security_1.SECURITY_CONFIG.MAX_DATA_SIZE) {
                    return {
                        isValid: false,
                        sanitized: {},
                        // Generic message - don't reveal size limits
                        message: "Invalid data",
                    };
                }
                // Check for suspicious content
                if ((0, security_1.containsForbiddenContent)(serialized)) {
                    return {
                        isValid: false,
                        sanitized: {},
                        // Generic message - don't reveal what patterns we check
                        message: "Invalid data",
                    };
                }
                return { isValid: true, sanitized: data };
            }
            catch (error) {
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
            if ((0, security_1.containsForbiddenContent)(data)) {
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
    function validateNuiAction(action) {
        if (!action || typeof action !== "string") {
            return false;
        }
        if ((0, security_1.containsForbiddenContent)(action)) {
            return false;
        }
        return true;
    }
    /**
     * Rate limiting for NUI events to prevent spam
     */
    class NuiRateLimit {
        constructor() {
            this.actionCounts = new Map();
            this.maxRequestsPerMinute = 60;
            this.windowMs = 60000; // 1 minute
        }
        isAllowed(action) {
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
    exports.nuiRateLimit = new NuiRateLimit();
    /**
     * Check if an action is allowed without validation side effects
     * Note: This is for internal use only - doesn't reveal validation details
     */
    function isNuiActionAllowed(action, nuiEvents) {
        return nuiEvents.includes(action);
    }
});
define("shared/envBrowser", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.isEnvBrowser = isEnvBrowser;
    function isEnvBrowser() {
        return typeof window !== "undefined" && typeof document !== "undefined";
    }
});
define("client/nui/fetchNui", ["require", "exports", "security/nuiSecurity", "shared/envBrowser"], function (require, exports, nuiSecurity_1, envBrowser_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.fetchNui = fetchNui;
    /**
     * Sends a NUI (Native UI) event to the backend and returns the response as a Promise.
     *
     * @template T - The expected response type.
     * @param eventName - The name of the NUI event to trigger.
     * @param data - Optional data to send with the event.
     * @param mockData - Optional mock data to return in browser environments for testing.
     */
    async function fetchNui(eventName, data, mockData) {
        // Security: Validate the event name (silent)
        if (!(0, nuiSecurity_1.validateNuiAction)(eventName)) {
            // Silent rejection - return empty promise that never resolves
            return new Promise(() => { });
        }
        // Security: Validate the data being sent (silent)
        if (data !== undefined) {
            const validation = (0, nuiSecurity_1.validateNuiMessage)(data);
            if (!validation.isValid) {
                // Silent rejection - return empty promise that never resolves
                return new Promise(() => { });
            }
            data = validation.sanitized;
        }
        const options = {
            method: "POST",
            headers: {
                "Content-Type": "application/json; charset=UTF-8",
            },
            body: JSON.stringify(data),
        };
        if ((0, envBrowser_1.isEnvBrowser)()) {
            if (mockData) {
                return new Promise((resolve) => {
                    setTimeout(() => resolve(mockData), 100);
                });
            }
            return new Promise((resolve) => {
                setTimeout(() => resolve({}), 100);
            });
        }
        const resourceName = GetCurrentResourceName();
        const resp = await fetch(`https://${resourceName}/${eventName}`, options);
        if (resp.ok) {
            return await resp.json();
        }
        throw new Error(`HTTP error! status: ${resp.status}`);
    }
});
define("client/nui/sendNui", ["require", "exports", "security/nuiSecurity"], function (require, exports, nuiSecurity_2) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.sendNui = sendNui;
    /**
     * Sends a NUI (Native UI) message to the specified action endpoint with optional data.
     *
     * @param action - The action endpoint to send the message to. Must pass whitelist validation.
     * @param data - Optional data payload to send. Must pass data validation.
     */
    function sendNui(action, data) {
        // Validate action against whitelist (silent validation)
        if (!(0, nuiSecurity_2.validateNuiAction)(action)) {
            // Silent rejection - no error details
            return;
        }
        // Validate data (silent validation)
        const validation = (0, nuiSecurity_2.validateNuiMessage)(data);
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
        }
        catch (error) {
            // Silent failure - don't reveal fetch details
        }
    }
});
define("client/index", ["require", "exports", "client/notify", "client/nui/fetchNui", "client/nui/sendNui"], function (require, exports, notify_1, fetchNui_1, sendNui_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.ui = exports.client = void 0;
    exports.client = {
        fetchNui: fetchNui_1.fetchNui,
        sendNui: sendNui_1.sendNui,
    };
    /**
     * Provides UI-related utilities and functions.
     *
     * @property notify - Function to trigger user notifications.
     */
    exports.ui = {
        notify: notify_1.notify,
    };
});
define("security/index", ["require", "exports", "security/security"], function (require, exports, security_2) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.security = void 0;
    exports.security = {
        containsForbiddenContent: security_2.containsForbiddenContent,
        containsForbiddenNameChars: security_2.containsForbiddenNameChars,
        sanitizeText: security_2.sanitizeText,
    };
});
define("client/resources", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.onResourceReady = onResourceReady;
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
    function onResourceReady(resourceName, callback) {
        const checkResourceState = () => {
            try {
                const state = window.GetResourceState(resourceName);
                if (state === "started") {
                    callback();
                }
                else {
                    setTimeout(checkResourceState, 1000);
                }
            }
            catch (err) {
                console.error(`Error checking resource state for ${resourceName}:`, err);
                setTimeout(checkResourceState, 1000);
            }
        };
        checkResourceState();
    }
});
define("utils/detection/framework-detection", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.getFramework = getFramework;
    /**
     * Detects and returns the current framework being used based on the state of known resources.
     */
    function getFramework() {
        const resourceStates = {
            qbcore: "qb-core",
            esx: "es_extended",
            qbox: "qbox-core",
            other: "",
        };
        if (typeof window.GetResourceState === "function") {
            for (const framework in resourceStates) {
                if (framework === "other")
                    continue;
                const resource = resourceStates[framework];
                try {
                    if (window.GetResourceState(resource) === "started") {
                        return framework;
                    }
                }
                catch (error) {
                    console.error(`Error checking resource state for ${resource}:`, error);
                }
            }
        }
        return "other";
    }
});
define("utils/index", ["require", "exports", "client/resources", "utils/detection/framework-detection"], function (require, exports, resources_1, framework_detection_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.utils = void 0;
    // Export empty utils object for now - extend as needed
    exports.utils = {
        onResourceReady: resources_1.onResourceReady,
        getFramework: framework_detection_1.getFramework,
    };
});
define("index", ["require", "exports", "client/index", "client/index", "security/index", "utils/index", "client/index", "utils/index"], function (require, exports, index_1, client_1, security_3, utils_1, client_2, utils_2) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    __exportStar(client_2, exports);
    __exportStar(utils_2, exports);
    // Export individual functions for FiveM
    if (typeof exports !== "undefined") {
        // Export individual functions
        Object.entries(client_1.client).forEach(([key, value]) => {
            if (typeof value === "function") {
                exports(key, value);
            }
        });
        Object.entries(utils_1.utils).forEach(([key, value]) => {
            if (typeof value === "function") {
                exports(key, value);
            }
        });
        Object.entries(security_3.security).forEach(([key, value]) => {
            if (typeof value === "function") {
                exports(key, value);
            }
        });
        Object.entries(index_1.ui).forEach(([key, value]) => {
            if (typeof value === "function") {
                exports(key, value);
            }
        });
    }
});
