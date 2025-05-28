<script lang="ts">
    import { hideUi, isDevMode } from "../stores/GeneralStores";
    import { inputStore } from "../stores/InputStores";
    import Icon from "./Icon.svelte";
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { handleKeyUp } from "../../utils/eventHandler";

    document.onkeyup = handleKeyUp;
    let inputData:any = $inputStore;


    function submit() {
        let returnData = [];

        let inputs = document.querySelectorAll('input');
        let textareas = document.querySelectorAll('textarea');
        let selects = document.querySelectorAll('select');
        selects.forEach((select: HTMLInputElement, index) => {
            let returnObj = {
                id:select.id,
                value: select.value,
            };
            returnData.push(returnObj)
        });
        textareas.forEach((textarea: HTMLTextAreaElement, index) => {
            let returnObj = {
                id:  textarea.id,
                value: textarea.value,
            };
            returnData.push(returnObj)
        });
        inputs.forEach((input: HTMLInputElement, index) => {
            let returnObj = {
                id: input.id,
				value: input.value,
            };
            
            returnData.push(returnObj)
		});
        console.log('returnData', JSON.stringify(returnData));
        if(!isDevMode) {
            fetchNui('input-callback', returnData);
        }

        closeInputs();
    }

    export function closeInputs(): void {
        
        if(!isDevMode) {
            fetchNui('input-close', { ok: true });
        }
		
		hideUi();
	}
</script>

<div class="input-base-wrapper">
    <div class="logo">
        <img src="./images/ps-logo.png" alt="ps-logo" />
    </div>

    <div class="input-form">
        {#each inputData.inputs as inputValue}
            <div class="input-wrapper">
                <div class="input-data-wrapper">
                    <div class="input-icon">
                        <Icon icon={inputValue.icon || 'fa-solid fa-user'} color="ps-text-green" classes="text-2xl" />
                    </div>
                    <div class="input-area">
                        {#if inputValue.type === 'text'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <input id={inputValue.id} type={inputValue.type} class="value" placeholder={inputValue.placeholder} value={inputValue.value} />
                        {:else if inputValue.type === 'number'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <input id={inputValue.id} type={inputValue.type} class="value" placeholder={inputValue.placeholder} value={Number(inputValue.value)} />
                        {:else if inputValue.type === 'password'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <input id={inputValue.id} type={inputValue.type} class="value" placeholder={inputValue.placeholder} value={inputValue.value} />
                        {:else if inputValue.type === 'textarea'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <textarea id={inputValue.id} class="value" placeholder={inputValue.placeholder} rows="3">{inputValue.value}</textarea>
                        {:else if inputValue.type === 'select'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <select id={inputValue.id} class="value">
                                {#each inputValue.options as option}
                                    <option value={option.value} selected={option.value === inputValue.value}>{option.label}</option>
                                {/each}
                            </select>
                        {:else if inputValue.type === 'checkbox'}
                            <p class="label">
                                {inputValue.label}
                            </p>
                            <input id={inputValue.id} type={inputValue.type} class="value" checked={inputValue.value} />
                        {/if}
                        {#if inputValue.message}
                            <p class="input-message">{inputValue.message}</p>
                        {/if}
                    </div>
                </div>
                <div class="horizontal-line"></div>
            </div>
        {/each}
    </div>

    <div class="button-wrapper">
        <button class="submit-btn" on:click={submit}>Submit</button>
        <button class="cancel-btn" on:click={closeInputs}>Cancel</button>
    </div>
</div>

<style>
    .input-base-wrapper {
        /* centering the view */
        position: absolute;
        left: 50%;  
        top: 50%;
        -webkit-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);  

        width: 25vw;
        min-height: 28vw;
        height: fit-content;

        overflow: hidden;

        background-color: var(--color-darkblue);
        border-radius: 0.3vw;

        padding: 0.5vw 2vw;
        display: flex;
        flex-direction: column;
    }

    .input-base-wrapper > .input-form {
        margin-top: 1vw;
        height: 100%;

        /* border: 0.1px solid red; */
    }

    .input-base-wrapper > .input-form > .input-wrapper {
        display: flex;
        flex-direction: column;
    }

    .input-base-wrapper > .input-form > .input-wrapper > .horizontal-line {
        width: inherit;
        height: 1px;
        background-color: var(--color-lightgrey);
    }
    .input-base-wrapper > .input-form > .input-wrapper > .input-message {
        font-size: 0.8vw;
        opacity: 0.85;
        color: var(--color-lightgrey);
        margin-top: 0.2vw;
        text-transform: capitalize;
    }
    .input-base-wrapper > .input-form > .input-wrapper > .input-data-wrapper {
        display: flex;
        flex-direction: row;

        padding: 0.5vw 0;
    }
    .input-base-wrapper > .input-form > .input-wrapper:not(:last-child) {
        margin-bottom: 1vw;
    }

    .input-base-wrapper > .input-form > .input-wrapper > .input-data-wrapper > .input-icon {
        margin-right: 0.75vw;
        width: 1.5vw;

        margin-top: auto;
        margin-bottom: auto;
    }
    .input-base-wrapper > .input-form > .input-wrapper > .input-data-wrapper > .input-area {
        display: flex;
        flex-direction: column;

        color: var(--color-lightgrey);
    }
    .input-base-wrapper > .input-form > .input-wrapper > .input-data-wrapper > .input-area > .label {
        font-size: 1vw;
        font-weight: 500 !important;
    }
    .input-base-wrapper > .input-form > .input-wrapper > .input-data-wrapper > .input-area > .value {
        font-size: 0.8vw;
        font-weight: 300 !important;
        width: 18vw;
        background-color: inherit;
        margin-top: 0.2vw;
    }

    input:focus {
		padding-left: 0;
		outline: none;
		border-bottom-width: 2px;
		border-bottom-color: var(--color-green);
		margin-bottom: -1px;
	}

    .input-base-wrapper > .button-wrapper {
        display: flex;
        flex-direction: row;
        justify-content: space-evenly;

        margin: 1.5vw auto 1.25vw auto;
        color: var(--color-black);
    }
    .input-base-wrapper > .button-wrapper > .submit-btn {
        background-color: var(--color-green);
    }
    .input-base-wrapper > .button-wrapper > .cancel-btn {
        background-color: var(--color-darkgrey);
    }

    button {
        border-radius: 0.3vw;
        padding: 0.3vw 1vw;
        text-transform: uppercase;
        font-weight: 500 !important;
    }
    button:not(:last-child) {
        margin-right: 0.5vw;
    }
</style>