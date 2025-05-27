<script lang="ts">
    import { hideUi, isDevMode } from "../stores/GeneralStores";
    import { inputStore } from "../stores/InputStores";
    import Icon from "./Icon.svelte";
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { handleKeyUp } from "../../utils/eventHandler";

    document.onkeyup = handleKeyUp;
    let inputData:any = $inputStore;

    onMount(() => {
        inputData = inputData.map((val) => {
            val.value = null;
            return val;
        });
    });

    function submit() {
        let returnData = [];

        let inputs = document.querySelectorAll('input');
        inputs.forEach((input: HTMLInputElement, index) => {
            let returnObj = {
                id: input.id,
				value: input.value,
                // compIndex: index
            };
            
            returnData.push(returnObj)
		});

        if(!isDevMode) {
            fetchNui('input-callback', returnData);
        }

        closeInputs();
    }

    export function closeInputs(): void {
        let inputs = document.querySelectorAll('input');
		inputs.forEach((input: HTMLInputElement) => {
			input.value = '';
		});

        inputData = [];

        if(!isDevMode) {
            fetchNui('input-close', { ok: true });
        }
		
		hideUi();
	}
</script>

<div class="input-base-wrapper">
    <div class="input-message">
        {inputData.title || "Please fill out this form"}
        {#if inputData.message}
            <p class="input-message">{inputData.message}</p>
        {/if}
        
    </div>
    <div class="input-form">
        {#each inputData as inputValue}
            <div class="input-wrapper">
                <div class="input-data-wrapper">
                    <div class="input-icon">
                        <Icon icon={inputValue.icon} color="ps-text-green" classes="text-2xl" />
                    </div>
                    <div class="input-area">
                        <p class="label">
                            {inputValue.label}
                        </p>
                        {#if inputValue.type === 'text' || inputValue.type === 'number'}
                            <input
                                type = {inputValue.type}
                                id={inputValue.id}
                                class="value"
                                placeholder={inputValue.placeholder || "Insert info"}
                            />
                        {:else if inputValue.type === 'checkbox'}
                            <label class="checkbox-wrapper">
                                <input
                                    type="checkbox"
                                    id={inputValue.id}
                                    checked={inputValue.value}
                                    on:change={(e) => handleInputChange(inputValue.id, e.target.checked)}
                                />
                                <span class="checkbox-label">{inputValue.checkboxLabel || "Enable"}</span>
                            </label>
                        {:else if inputValue.type === 'select'}
                            <select
                                id={inputValue.id}
                                class="value"
                            >
                                {#each inputValue.options as option}
                                    <option value={option.value}>
                                        {option.label}
                                    </option>
                                {/each}
                            </select>
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
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 28vw;
    max-width: 400px;
    background-color: var(--color-darkblue);
    border-radius: 0.6vw;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    padding: 2vw 2.5vw;
    display: flex;
    flex-direction: column;
    color: white;
}

.input-message {
    font-size: clamp(1rem, 1.4vw, 1.6rem);
    font-weight: 600;
    text-transform: uppercase;
    margin-bottom: 1.2vw;
    text-align: center;
    color: white;
}

.input-form {
    display: flex;
    flex-direction: column;
    gap: 1vw;
}

.input-wrapper {
    display: flex;
    flex-direction: column;
    gap: 0.5vw;
}

.horizontal-line {
    width: 100%;
    height: 1px;
    background-color: var(--color-lightgrey);
}

.input-message {
    font-size: clamp(0.75rem, 0.9vw, 1rem);
    opacity: 0.7;
    color: var(--color-lightgrey);
    text-transform: capitalize;
}

.input-data-wrapper {
    display: flex;
    align-items: center;
    gap: 1vw;
}

.input-icon {
    width: 1.5vw;
    height: 1.5vw;
    margin-top: auto;
    margin-bottom: auto;
    opacity: 0.6;
}

.input-area {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.input-area .label {
    font-size: clamp(0.9rem, 1.1vw, 1.2rem);
    font-weight: 500;
    margin-bottom: 0.3vw;
}

.input-area .value {
    font-size: clamp(0.75rem, 0.9vw, 1rem);
    font-weight: 300;
    background: transparent;
    border: none;
    padding-left: 0.5vw;
    transition: border-color 0.3s ease;
    width: 100%;
    outline: none;
}

.input-area .value:focus {
    border-bottom-color: var(--color-green);
    padding-left: 0;
}

/* Button Wrapper */
.button-wrapper {
    display: flex;
    justify-content: space-between;
    margin-top: 1.5vw;
    gap: 1vw;
}

.submit-btn,
.cancel-btn {
    flex: 1;
    padding: 0.6vw 1.2vw;
    font-size: clamp(0.8rem, 0.95vw, 1.1rem);
    font-weight: 600;
    text-transform: uppercase;
    border-radius: 0.4vw;
    border: none;
    cursor: pointer;
    transition: all 0.2s ease;
}

.submit-btn {
    background-color: var(--color-green);
    color: white;
}

.submit-btn:hover {
    background-color: #2ecc71; /* brighter green */
}

.cancel-btn {
    background-color: var(--color-darkgrey);
    color: var(--color-text);
}

.cancel-btn:hover {
    background-color: #95a5a6;
}


.input-wrapper {
    animation: fadeIn 0.3s ease forwards;
}
</style>