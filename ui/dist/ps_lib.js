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
define("client/index", ["require", "exports", "client/notify"], function (require, exports, notify_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.client = void 0;
    exports.client = {
        notify: notify_1.notify,
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
define("utils/index", ["require", "exports", "client/resources"], function (require, exports, resources_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.utils = void 0;
    // Export empty utils object for now - extend as needed
    exports.utils = {
        onResourceReady: resources_1.onResourceReady,
    };
});
define("index", ["require", "exports", "client/index", "utils/index", "client/index", "utils/index"], function (require, exports, client_1, utils_1, client_2, utils_2) {
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
define("security/inputValidation", ["require", "exports", "security/security"], function (require, exports, security_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.validateTagInput = validateTagInput;
    exports.validateReportTitle = validateReportTitle;
    exports.validateSearchQuery = validateSearchQuery;
    exports.validateNotesInput = validateNotesInput;
    exports.validateSerialNumber = validateSerialNumber;
    /**
     * Input validation utilities using the global security config
     */
    /**
     * Validates and sanitizes tag input
     */
    function validateTagInput(tag) {
        if (!tag || typeof tag !== "string") {
            return {
                isValid: false,
                sanitized: "",
                message: "Tag must be a non-empty string",
            };
        }
        const trimmed = tag.trim();
        // Check length
        if (trimmed.length === 0) {
            return {
                isValid: false,
                sanitized: "",
                message: "Invalid input",
            };
        }
        if (trimmed.length > security_1.SECURITY_CONFIG.MAX_INSTANCE_NAME_LENGTH) {
            return {
                isValid: false,
                sanitized: trimmed.substring(0, security_1.SECURITY_CONFIG.MAX_INSTANCE_NAME_LENGTH),
                message: "Input too long",
            };
        }
        // Check for forbidden characters
        if ((0, security_1.containsForbiddenNameChars)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        // Check for suspicious content
        if ((0, security_1.containsForbiddenContent)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
    /**
     * Validates report title input
     */
    function validateReportTitle(title) {
        if (!title || typeof title !== "string") {
            return {
                isValid: false,
                sanitized: "",
                message: "Title must be a non-empty string",
            };
        }
        const trimmed = title.trim();
        // Allow longer titles for reports but still limit them
        const MAX_TITLE_LENGTH = 200;
        if (trimmed.length > MAX_TITLE_LENGTH) {
            return {
                isValid: false,
                sanitized: trimmed.substring(0, MAX_TITLE_LENGTH),
                message: `Input too long`,
            };
        }
        // Check for forbidden characters (less strict for titles)
        if ((0, security_1.containsForbiddenContent)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
    /**
     * Validates search query input
     */
    function validateSearchQuery(query) {
        if (!query || typeof query !== "string") {
            return { isValid: true, sanitized: "" }; // Empty search is valid
        }
        const trimmed = query.trim();
        // Limit search query length
        const MAX_SEARCH_LENGTH = 100;
        if (trimmed.length > MAX_SEARCH_LENGTH) {
            return {
                isValid: false,
                sanitized: trimmed.substring(0, MAX_SEARCH_LENGTH),
                message: `Input too long`,
            };
        }
        // Check for suspicious content in search
        if ((0, security_1.containsForbiddenContent)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
    /**
     * Validates text area/notes input
     */
    function validateNotesInput(notes) {
        if (!notes || typeof notes !== "string") {
            return { isValid: true, sanitized: "" }; // Empty notes are valid
        }
        const trimmed = notes.trim();
        // Limit notes length
        const MAX_NOTES_LENGTH = 2000;
        if (trimmed.length > MAX_NOTES_LENGTH) {
            return {
                isValid: false,
                sanitized: trimmed.substring(0, MAX_NOTES_LENGTH),
                message: `Input too long`,
            };
        }
        // Check for suspicious content
        if ((0, security_1.containsForbiddenContent)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
    /**
     * Validates evidence serial number input
     */
    function validateSerialNumber(serial) {
        if (!serial || typeof serial !== "string") {
            return { isValid: true, sanitized: "" }; // Empty serial is valid
        }
        const trimmed = serial.trim();
        // Limit serial length
        const MAX_SERIAL_LENGTH = 50;
        if (trimmed.length > MAX_SERIAL_LENGTH) {
            return {
                isValid: false,
                sanitized: trimmed.substring(0, MAX_SERIAL_LENGTH),
                message: `Input too long`,
            };
        }
        // Check for forbidden characters
        if ((0, security_1.containsForbiddenNameChars)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        // Check for suspicious content
        if ((0, security_1.containsForbiddenContent)(trimmed)) {
            return {
                isValid: false,
                sanitized: trimmed,
                message: "Invalid input",
            };
        }
        return { isValid: true, sanitized: trimmed };
    }
});
define("security/nuiSecurity", ["require", "exports", "security/security"], function (require, exports, security_2) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.nuiRateLimit = void 0;
    exports.validateNuiMessage = validateNuiMessage;
    exports.validateNuiAction = validateNuiAction;
    exports.securePostMessage = securePostMessage;
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
                if (serialized.length > security_2.SECURITY_CONFIG.MAX_DATA_SIZE) {
                    return {
                        isValid: false,
                        sanitized: {},
                        // Generic message - don't reveal size limits
                        message: "Invalid data",
                    };
                }
                // Check for suspicious content
                if ((0, security_2.containsForbiddenContent)(serialized)) {
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
            if ((0, security_2.containsForbiddenContent)(data)) {
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
        if ((0, security_2.containsForbiddenContent)(action)) {
            return false;
        }
        return true;
    }
    /**
     * Secure wrapper for postMessage to FiveM
     */
    function securePostMessage(action, data) {
        // Validate action against whitelist (silent validation)
        if (!validateNuiAction(action)) {
            // Silent rejection - no error details
            return;
        }
        // Validate data (silent validation)
        const validation = validateNuiMessage(data);
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
define("utils/detection/framework-detection", ["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.getFramework = getFramework;
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
define("utils/nui/fetchNui", ["require", "exports", "security/nuiSecurity", "shared/envBrowser"], function (require, exports, nuiSecurity_1, envBrowser_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.fetchNui = fetchNui;
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
