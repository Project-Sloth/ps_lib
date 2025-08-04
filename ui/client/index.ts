import { notify } from "./notify";
export interface PSClient {
	notify: typeof notify;
}

export const client: PSClient = {
	notify: notify,
};
