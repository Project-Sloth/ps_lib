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
    <div class="form-overlay">
        <div class="form-container">
            <div class="form-header">
                <h2 class="form-title">{$inputFormName}</h2>
                <div class="form-title-accent"></div>
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
                                    class="form-input form-textarea"
                                    rows="4"
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
    </div>
{/if}

<style>
    .form-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .form-container {
        background: linear-gradient(135deg, #2a2a2a 0%, #1f1f1f 100%);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 20px;
        padding: 32px;
        width: min(450px, 90vw);
        max-height: 80vh;
        overflow: hidden;
        box-shadow: 
            0 10px 30px rgba(0, 0, 0, 0.3),
            inset 0 1px 0 rgba(255, 255, 255, 0.1);
        position: relative;
    }

    .form-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(251, 191, 36, 0.3), transparent);
    }

    .form-header {
        margin-bottom: 32px;
    }

    .form-title {
        font-size: 24px;
        font-weight: 600;
        color: #e5e5e5;
        text-align: center;
        margin: 0 0 8px 0;
        letter-spacing: -0.5px;
    }

    .form-title-accent {
        width: 40px;
        height: 2px;
        background: linear-gradient(90deg, #FBBF24, #f59e0b);
        margin: 0 auto;
        border-radius: 2px;
    }

    .form-group {
        margin-bottom: 24px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 500;
        color: #d1d1d1;
        margin-bottom: 8px;
        letter-spacing: 0.1px;
    }

    .required {
        color: #ff6b6b;
        margin-left: 2px;
    }

    .form-description {
        font-size: 12px;
        color: #a5a5a5;
        margin-bottom: 10px;
        line-height: 1.4;
    }

    .form-input, .form-select {
        width: 100%;
        padding: 14px 16px;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 12px;
        color: #e5e5e5;
        font-size: 14px;
        transition: all 0.2s ease;
        box-sizing: border-box;
    }

    .form-select {
        appearance: none;
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23a5a5a5' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 12px center;
        background-size: 16px;
        padding-right: 40px;
    }

    .form-select option {
        background: #2a2a2a;
        color: #e5e5e5;
        padding: 8px 12px;
        border: none;
    }

    .form-select:focus {
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23FBBF24' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
    }

    .form-textarea {
        resize: vertical;
        min-height: 80px;
        font-family: inherit;
    }

    .form-input:focus, .form-select:focus {
        outline: none;
        border-color: rgba(251, 191, 36, 0.5);
        box-shadow: 0 0 0 3px rgba(251, 191, 36, 0.1);
        background: rgba(255, 255, 255, 0.08);
    }

    .form-input::placeholder {
        color: rgba(255, 255, 255, 0.4);
    }

    .checkbox-container {
        display: flex;
        align-items: flex-start;
        cursor: pointer;
        position: relative;
        padding-left: 28px;
        margin-bottom: 12px;
        font-size: 14px;
        user-select: none;
        line-height: 1.4;
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
        top: 2px;
        left: 0;
        height: 18px;
        width: 18px;
        background-color: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 4px;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .checkbox-container:hover .checkmark {
        border-color: rgba(251, 191, 36, 0.5);
        background-color: rgba(251, 191, 36, 0.05);
    }

    .form-checkbox:checked ~ .checkmark {
        background-color: #FBBF24;
        border-color: #FBBF24;
    }

    .checkmark:after {
        content: "";
        position: absolute;
        display: none;
        width: 5px;
        height: 8px;
        border: solid #1f1f1f;
        border-width: 0 2px 2px 0;
        transform: rotate(45deg);
        top: 1px;
    }

    .form-checkbox:checked ~ .checkmark:after {
        display: block;
    }

    .checkbox-label {
        color: #d1d1d1;
        margin-left: 4px;
        flex: 1;
    }

    .form-actions {
        display: flex;
        justify-content: center;
        margin-top: 32px;
        padding-top: 24px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    .btn {
        padding: 14px 32px;
        border: none;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        min-width: 120px;
        letter-spacing: 0.5px;
    }

    .btn-primary {
        background: linear-gradient(135deg, #FBBF24 0%, #f59e0b 100%);
        color: #1f1f1f;
        box-shadow: 0 4px 12px rgba(251, 191, 36, 0.3);
    }

    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(251, 191, 36, 0.4);
    }

    .btn-primary:active {
        transform: translateY(0);
    }
    .input-scroll-container {
        max-height: 400px;
        overflow-y: auto;
        padding-right: 8px;
        margin-right: -8px;
    }

    .input-scroll-container::-webkit-scrollbar {
        width: 6px;
    }

    .input-scroll-container::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 3px;
    }

    .input-scroll-container::-webkit-scrollbar-thumb {
        background: rgba(251, 191, 36, 0.3);
        border-radius: 3px;
    }

    .input-scroll-container::-webkit-scrollbar-thumb:hover {
        background: rgba(251, 191, 36, 0.5);
    }

    /* Responsive design */
    @media (max-width: 600px) {
        .form-container {
            padding: 24px;
            width: 90vw;
        }

        .form-title {
            font-size: 20px;
        }

        .form-input, .form-select {
            padding: 12px;
        }

        .btn {
            padding: 12px 24px;
            min-width: 100px;
        }
    }
</style>