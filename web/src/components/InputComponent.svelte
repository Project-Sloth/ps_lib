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
        selects.forEach((select: HTMLSelectElement, index) => {
            let type = select.tagName.toLowerCase();
            let returnObj = {
                id: select.id,
                value: JSON.parse(select.value).value ,
                type: type,
                returnType: JSON.parse(select.value).returnType || 'string',
            };
            returnData.push(returnObj);
        });
        textareas.forEach((textarea: HTMLTextAreaElement, index) => {
            let returnObj = {
                id:  textarea.id,
                value: textarea.value,
                type: textarea.type,
            };
            returnData.push(returnObj)
        });
        inputs.forEach((input: HTMLInputElement, index) => {
            let returnObj = {
                id: input.id,
                value: input.type === 'checkbox' ? input.checked : input.value,
                type: input.type,
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
    <div class ="input-header">
        <h1>{inputData.title}</h1>
    </div>
    <div class="input-form">
        {#each inputData.inputs as inputValue}
            <div class="input-wrapper">
                <div class="input-data-wrapper">
                    <div class="input-icon">
                        <Icon icon={inputValue.icon || 'fa-solid fa-user'} styleColor="#FBBF24" classes="text-2xl" />
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
                            <select
                                id={inputValue.id}
                                class="value"
                                on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }}
                            >
                                {#each inputValue.options as option}
                                    <option value={JSON.stringify({ value: option.value, returnType: option.returnType})} selected={option.value === inputValue.value}>
                                        {option.label}
                                    </option>
                                {/each}
                            </select>
                        {:else if inputValue.type === 'checkbox'}
                           <p class="label">
                               {inputValue.label}
                           </p>
                           <input 
                               id={inputValue.id} 
                               type= "checkbox" 
                               class="value" 
                               bind:checked={inputValue.value}
                               on:click={() => inputValue.value}
                           />
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
    :root {
      --dark-bg: rgb(23, 23, 23);       
      --card-dark-bg: rgb(14, 15, 15);  
      --off-white: rgba(255, 255, 255, 0.7);
      --yellow: #FBBF24;
    }

    .input-base-wrapper {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 25vw;
        min-height: 10vw;
        max-height: 80vh;
        overflow-y: auto;
        background-color: var(--card-dark-bg);
        border-radius: 0.3vw;
        padding: 0.5vw 2vw;
        display: flex;
        flex-direction: column;
        box-shadow: 0 0 1vw rgba(0, 0, 0, 0.5);
        font-family: sans-serif;
    }

    .input-base-wrapper::-webkit-scrollbar {
        display: none;
    }
    .input-base-wrapper::-webkit-scrollbar-thumb {
        background-color: var(--off-white);
        border-radius: 0.2vw;
    }
    .input-header {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 1vw;
        height: 10%;

    }
    .input-header h1 {
        font-size: 1.5vw;
        color: var(--off-white);
        font-weight: 600;
        text-align: center;
        margin: 0;
    }
    .input-form {
        margin-top: 1vw;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }

    .input-wrapper {
        display: flex;
        flex-direction: column;
        position: relative;
    }

    .input-wrapper:not(:last-child) {
        margin-bottom: 1vw;
    }

    .horizontal-line {
        width: 100%;
        height: 1px;
        background-color: rgba(255, 255, 255, 0.1);
    }

    .input-message {
        font-size: 0.8vw;
        opacity: 0.6;
        color: var(--off-white);
        margin-top: 0.2vw;
        text-transform: capitalize;
    }

    .input-data-wrapper {
        display: flex;
        flex-direction: row;
        align-items: center;
        padding: 0.5vw 0;
    }

    .input-icon {
        margin-right: 0.75vw;
        width: 1.5vw;
        display: flex;
        align-items: center;
    }

    .input-area {
        display: flex;
        flex-direction: column;
        color: var(--off-white);
    }

    .input-area .label {
        font-size: 1vw;
        font-weight: 500;
        margin-bottom: 0.3vw;
    }

    .input-area .value {
        font-size: 0.8vw;
        font-weight: 300;
        width: 18vw;
        background-color: transparent;
        margin-top: 0.2vw;
        border: none;
        color: var(--off-white);
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.3vw 0;
    }

    .input-area .value:focus {
        outline: none;
        border-bottom: 2px solid var(--yellow);
    }

    .button-wrapper {
        display: flex;
        justify-content: center;
        gap: 1vw;
        margin: 1.5vw auto 1.25vw auto;
    }

    .submit-btn,
    .cancel-btn {
        border-radius: 0.3vw;
        padding: 0.3vw 1vw;
        text-transform: uppercase;
        font-weight: 500;
        border: none;
        cursor: pointer;
        transition: background 0.2s ease-in-out;
    }

    .submit-btn {
        background-color: var(--yellow);
        color: black;
    }

    .submit-btn:hover {
        background-color: #f59e0b;
    }

    .cancel-btn {
        background-color: rgba(255, 255, 255, 0.1);
        color: var(--off-white);
    }

    .cancel-btn:hover {
        background-color: rgba(255, 255, 255, 0.2);
    }
</style>
