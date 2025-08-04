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
    exports.getResource = getResource;
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
    function getResource(resourceName) {
        try {
            return window.GetResourceState(resourceName) ?? "unknown";
        }
        catch (err) {
            console.error(`Error getting resource state for ${resourceName}:`, err);
            return "unknown";
        }
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
