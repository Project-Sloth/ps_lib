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
    export function getResource(resourceName: string): string;
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
declare module "utils/detection/framework-detection" {
    import { Framework } from "shared/types";
    function getFramework(): Framework;
    export { getFramework };
}
