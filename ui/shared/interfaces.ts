import { FontAwesomeClassName, NotifyType } from "./types";

export interface NotificationOptions {
	text: string;
	type: NotifyType;
	icon: FontAwesomeClassName;
	duration: number;
}
