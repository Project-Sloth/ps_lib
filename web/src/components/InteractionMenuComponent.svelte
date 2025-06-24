<script lang="ts">
    import { hideUi, isDevMode } from "../stores/GeneralStores";
    import { inputStore } from "../stores/InputStores";
    import Icon from "./Icon.svelte";
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { handleKeyUp } from "../../utils/eventHandler";

    document.onkeyup = handleKeyUp;
    let inputData: any = $inputStore;

    function submit() {
        let returnData = [];

        let inputs = document.querySelectorAll('input');
        let textareas = document.querySelectorAll('textarea');
        let selects = document.querySelectorAll('select');

        selects.forEach((select: HTMLSelectElement) => {
            returnData.push({
                id: select.id,
                value: JSON.parse(select.value).value,
                type: select.tagName.toLowerCase(),
                returnType: JSON.parse(select.value).returnType || 'string',
            });
        });

        textareas.forEach((textarea: HTMLTextAreaElement) => {
            returnData.push({
                id: textarea.id,
                value: textarea.value,
                type: textarea.type,
            });
        });

        inputs.forEach((input: HTMLInputElement) => {
            returnData.push({
                id: input.id,
                value: input.type === 'checkbox' ? input.checked : input.value,
                type: input.type,
            });
        });

        if (!isDevMode) {
            fetchNui('input-callback', returnData);
        }

        closeInputs();
    }

    export function closeInputs(): void {
        if (!isDevMode) {
            fetchNui('input-close', { ok: true });
        }
        hideUi();
    }
</script>

<div class="input-base-wrapper">
    <div class="input-header">
        <h1>{inputData.title}</h1>
    </div>

    <form class="input-form" on:submit|preventDefault={submit}>
        {#each inputData.inputs as inputValue}
            <div class="input-group">
                <label class="input-label">{inputValue.label}</label>
                <div class="input-field-wrapper">
                    <span class="input-icon">
                        <Icon icon={inputValue.icon || 'fa-solid fa-user'} styleColor="#FBBF24" classes="text-xl" />
                    </span>

                    {#if inputValue.type === 'text'}
                        <input id={inputValue.id} type="text" class="input-field" placeholder={inputValue.placeholder} on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }} />

                    {:else if inputValue.type === 'number'}
                        <input id={inputValue.id} type="number" class="input-field" placeholder={inputValue.placeholder} on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }} />

                    {:else if inputValue.type === 'password'}
                        <input id={inputValue.id} type="password" class="input-field" placeholder={inputValue.placeholder} on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }} />

                    {:else if inputValue.type === 'textarea'}
                        <textarea id={inputValue.id} class="input-field" rows="3" placeholder={inputValue.placeholder} on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }}></textarea>

                    {:else if inputValue.type === 'select'}
                        <select id={inputValue.id} class="input-field" on:change={(e) => {
                                    inputValue.value = e.target.value;
                                }}>
                            {#each inputValue.options as option}
                                <option value={JSON.stringify({ value: option.value, returnType: option.returnType })} selected={option.value === inputValue.value}>
                                    {option.label}
                                </option>
                            {/each}
                        </select>

                    {:else if inputValue.type === 'checkbox'}
                        <label class="checkbox-container">
                            <input type="checkbox" id={inputValue.id} class="checkbox-input" style="justify-content: left;" bind:checked={inputValue.value} />
                            <span class="checkbox-label">{inputValue.label}</span>
                        </label>
                    {/if}
                </div>

                {#if inputValue.message}
                    <p class="input-message">{inputValue.message}</p>
                {/if}
            </div>
        {/each}

        <div class="button-wrapper">
            <button type="submit" class="btn primary">Submit</button>
            <button type="button" class="btn secondary" on:click={closeInputs}>Cancel</button>
        </div>
    </form>
</div>
<style>
   :root {
  --dark-bg: rgb(23, 23, 23);
  --card-dark-bg: rgb(14, 15, 15);
  --off-white: rgba(255, 255, 255, 0.7);
  --accent-color: #FBBF24;
  --border-color: rgba(255, 255, 255, 0.1);
  --focus-color: #FBBF24;
  --font-main: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.input-base-wrapper {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  width: 30vw;
  min-height: 15vh;
  max-height: 85vh;
  overflow-y: auto;
  background-color: var(--card-dark-bg);
  border-radius: 0.8vw;
  padding: 1.5vw 2vw;
  box-shadow: 0 0 1vw rgba(0, 0, 0, 0.5);
  font-family: var(--font-main);
  color: var(--off-white);
}

/* Scrollbar */
.input-base-wrapper::-webkit-scrollbar {
  width: 0.3vw;
}

.input-base-wrapper::-webkit-scrollbar-thumb {
  background-color: var(--accent-color);
  border-radius: 0.2vw;
}

/* Header */
.input-header h1 {
  font-size: 1.6vw;
  font-weight: 600;
  text-align: center;
  margin-bottom: 1vw;
  color: var(--off-white);
}

/* Inputs */
.input-form {
  display: flex;
  flex-direction: column;
  gap: 1.2vw;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 0.4vw;
}

.input-label {
  font-size: 1vw;
  font-weight: 500;
  color: var(--off-white);
}

.input-field-wrapper {
  display: flex;
  align-items: center;
  position: relative;
}

.input-icon {
  position: absolute;
  left: 1vw;
  color: var(--accent-color);
  pointer-events: none;
}

.input-field {
  width: 100%;
  padding: 0.5vw 2.5vw;
  font-size: 1vw;
  font-weight: 400;
  background: transparent;
  color: var(--off-white);
  border: 1px solid var(--border-color);
  border-radius: 0.4vw;
  outline: none;
  transition: all 0.2s ease-in-out;
}

.input-field:focus {
  border-color: var(--focus-color);
  background-color: rgba(255, 204, 0, 0.05);
}

/* Textarea & Select */
.input-field::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

/* Checkbox */
.checkbox-container {
  display: flex;
  align-items: center;
  gap: 0.5vw;
  cursor: pointer;
}

.checkbox-input {
  appearance: none;
  width: 1.2vw;
  height: 1.2vw;
  background-color: transparent;
  border: 2px solid var(--border-color);
  border-radius: 0.2vw;
  cursor: pointer;
  position: relative;
  transition: border-color 0.2s ease;
}

.checkbox-input:checked::after {
  content: '';
  position: absolute;
  left: 0.3vw;
  top: 0.1vw;
  width: 0.4vw;
  height: 0.8vw;
  border: solid var(--accent-color);
  border-width: 0 0.2vw 0.2vw 0;
  transform: rotate(45deg);
}

.checkbox-label {
  font-size: 1vw;
}

/* Helper message */
.input-message {
  font-size: 0.85vw;
  opacity: 0.6;
  color: var(--off-white);
  margin-top: 0.2vw;
}

/* Buttons */
.button-wrapper {
  display: flex;
  justify-content: center;
  gap: 1.5vw;
  margin-top: 1.5vw;
}

.btn {
  padding: 0.5vw 1.5vw;
  font-size: 1vw;
  font-weight: 500;
  text-transform: uppercase;
  border-radius: 0.4vw;
  cursor: pointer;
  transition: background 0.2s ease;
  border: none;
}

.primary {
  background-color: var(--accent-color);
  color: black;
}

.primary:hover {
  background-color: #eab308;
}

.secondary {
  background-color: transparent;
  color: var(--off-white);
  border: 1px solid var(--border-color);
}

.secondary:hover {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>