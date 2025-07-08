<script lang="ts">
    import { isInputting, inputData, inputFormName } from '../store/inputStore';
    import { fetchNui } from '../utils/fetchNui';
    interface InputItem {
        type: 'text' | 'number' | 'password' | 'select' | 'checkbox' | 'longtext' | 'textarea';
        title: string;
        description?: string;
        placeholder?: string;
        required: boolean;
        options?: { value: string; label: string }[];
    }

    let formData: Record<string, any> = {};
    $: if ($inputData.length > 0) {
        initializeFormData();
    }

     function initializeFormData() {
        formData = {};
        $inputData.forEach((item: InputItem, index: number) => {
            const key = `field_${index}`;
            if (item.type === 'checkbox') {
                formData[key] = false;
            } else {
                formData[key] = '';
            }
        });
    }

    function handleSubmit() {
        let isValid = true;
        $inputData.forEach((item: InputItem, index: number) => {
            const value = formData[`field_${index}`];
            if (item.required && (value === '' || value === false)) {
                isValid = false;
            }
        });

        if (!isValid) {
            return;
        }
        const dataArray: any[] = [];
        $inputData.forEach((_, index: number) => {
            dataArray.push(formData[`field_${index}`]);
        });
        fetchNui('hideUI');
        fetchNui('submitForm', dataArray);
        inputData.set([]);
        isInputting.set(false);
    }
</script>


{#if $isInputting}
    <div class="form-container">
        <div class="form-header">
            <h2 class="form-title">{$inputFormName}</h2>
        </div>
        <form on:submit|preventDefault={handleSubmit}>
            <div class="input-scroll-container">
                {#each $inputData as item, index}
                    <div class="form-group">
                        <label class="form-label" for="field_{index}">
                            {item.title}
                            {#if item.required}
                                <span class="required">*</span>
                            {/if}
                        </label>
                        {#if item.description}
                            <p class="form-description">{item.description}</p>
                        {/if}

                        {#if item.type === 'text'}
                            <input
                                id="field_{index}"
                                type="text"
                                class="form-input"
                                placeholder={item.placeholder || ''}
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            />
                        {:else if item.type === 'number'}
                            <input
                                id="field_{index}"
                                type="number"
                                class="form-input"
                                placeholder={item.placeholder || ''}
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            />
                        {:else if item.type === 'longtext'}
                            <input
                                id="field_{index}"
                                type="text"
                                class="form-input"
                                placeholder={item.placeholder || ''}
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            />
                        {:else if item.type === 'textarea'}
                            <textarea
                                id="field_{index}"
                                class="form-input"
                                placeholder={item.placeholder || ''}
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            />
                        {:else if item.type === 'password'}
                            <input
                                id="field_{index}"
                                type="password"
                                class="form-input"
                                placeholder={item.placeholder || ''}
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            />
                        {:else if item.type === 'select'}
                            <select
                                id="field_{index}"
                                class="form-select"
                                bind:value={formData[`field_${index}`]}
                                required={item.required}
                            >
                                <option value="">Choose an option...</option>
                                {#each item.options || [] as option}
                                    <option value={option.value}>{option.label}</option>
                                {/each}
                            </select>
                        {:else if item.type === 'checkbox'}
                            <label class="checkbox-container">
                                <input
                                    id="field_{index}"
                                    type="checkbox"
                                    class="form-checkbox"
                                    bind:checked={formData[`field_${index}`]}
                                />
                                <span class="checkmark"></span>
                                <span class="checkbox-label">{item.title}</span>
                            </label>
                        {/if}
                    </div>
                {/each}
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary" on:click={handleSubmit}>
                    Submit
                </button>
            </div>
        </form>
    </div>
{/if}

<style>
    .form-container {
        background: rgba(22, 22, 22, 1.0);
        border: 2px solid #FBBF24;
        border-radius: 12px;
        padding: 30px;
        width: 25%;
        overflow-y: auto;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        position: fixed;
    }
    .form-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }
    .form-title {
        font-size: 24px;
        font-weight: bold;
        color: #FBBF24;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
        margin: 0;
    }
    .close-btn {
        background: none;
        border: none;
        color: #FBBF24;
        font-size: 24px;
        cursor: pointer;
        padding: 5px 10px;
        border-radius: 4px;
        transition: all 0.2s ease;
    }
    .close-btn:hover {
        background: rgba(251, 191, 36, 0.1);
        transform: scale(1.1);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-label {
        display: block;
        font-size: 16px;
        font-weight: 600;
        color: #FBBF24;
        margin-bottom: 8px;
    }
    .required {
        color: #ff6b6b;
    }
    .form-description {
        font-size: 12px;
        color: #cccccc;
        margin-bottom: 10px;
        opacity: 0.9;
    }
    .form-input {
        width: 80%;
        padding: 12px 16px;
        background: rgba(20, 20, 20, 0.8);
        border: 1px solid rgba(251, 191, 36, 0.3);
        border-radius: 8px;
        color: white;
        font-size: 14px;
        transition: all 0.3s ease;
    }
    .form-select {
        width: 87%;
        padding: 12px 16px;
        background: rgba(20, 20, 20, 0.8);
        border: 1px solid rgba(251, 191, 36, 0.3);
        border-radius: 8px;
        color: white;
        font-size: 14px;
        transition: all 0.3s ease;
    }
    .form-input:focus,
    .form-select:focus {
        outline: none;
        border-color: #FBBF24;
        box-shadow: 0 0 0 2px rgba(251, 191, 36, 0.2);
        background: rgba(30, 30, 30, 0.9);
    }
    .form-input::placeholder {
        color: rgba(255, 255, 255, 0.5);
    }
    .checkbox-container {
        display: flex;
        align-items: center;
        cursor: pointer;
        position: relative;
        padding-left: 35px;
        margin-bottom: 12px;
        font-size: 14px;
        user-select: none;
    }
    .form-checkbox {
        position: absolute;
        opacity: 0;
        cursor: pointer;
        height: 0;
        width: 0;
    }
    .checkmark {
        position: absolute;
        top: 0;
        left: 0;
        height: 20px;
        width: 20px;
        background-color: rgba(20, 20, 20, 0.8);
        border: 1px solid rgba(251, 191, 36, 0.3);
        border-radius: 4px;
        transition: all 0.2s ease;
    }
    .checkbox-container:hover .checkmark {
        border-color: #FBBF24;
    }
    .form-checkbox:checked ~ .checkmark {
        background-color: #FBBF24;
        border-color: #FBBF24;
    }
    .checkmark:after {
        content: "";
        position: absolute;
        display: none;
    }
    .form-checkbox:checked ~ .checkmark:after {
        display: block;
    }
    .checkbox-container .checkmark:after {
        left: 7px;
        top: 3px;
        width: 5px;
        height: 10px;
        border: solid black;
        border-width: 0 3px 3px 0;
        transform: rotate(45deg);
    }
    .checkbox-label {
        color: white;
        margin-left: 10px;
    }
    .form-actions {
        display: flex;
        gap: 15px;
        justify-content: flex-end;
        margin-top: 30px;
    }
    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        min-width: 100px;
    }
    .btn-primary {
        background: #FBBF24;
        color: black;
    }
    .btn-primary:hover {
        background: #f59e0b;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(251, 191, 36, 0.3);
    }
    .btn-secondary {
        background: rgba(60, 60, 60, 0.8);
        color: white;
        border: 1px solid rgba(251, 191, 36, 0.3);
    }
    .btn-secondary:hover {
        background: rgba(80, 80, 80, 0.9);
        border-color: #FBBF24;
        transform: translateY(-1px);
    }

    /* Scrollable container */
    .input-scroll-container {
        max-height: 400px;
        overflow-y: auto;
        padding-right: 10px;
    }

    .input-scroll-container::-webkit-scrollbar {
        width: 8px;
    }

    .input-scroll-container::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.3);
        border-radius: 4px;
    }

    .input-scroll-container::-webkit-scrollbar-thumb {
        background: rgba(251, 191, 36, 0.5);
        border-radius: 4px;
    }

    .input-scroll-container::-webkit-scrollbar-thumb:hover {
        background: rgba(251, 191, 36, 0.7);
    }
</style>