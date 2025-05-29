import { writable, type Writable } from 'svelte/store';
import type { IInput } from './../interfaces/IInput';
import { showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from '../enums/UIComponentsEnum';

export const inputStore: Writable<Array<IInput>> = writable([]);

/** Show the input component */
export function showInput(data: Array<IInput>): void {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.Input);

	inputStore.set(data);
}
