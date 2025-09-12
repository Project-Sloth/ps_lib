<script lang="ts">
    import { fetchNui } from '../utils/fetchNui';
    import { contextMenuShown, contextMenuItems } from '../store/ContextMenu';
    import Icon from "./Icons.svelte";

    function hideContextMenu() {
        contextMenuShown.set(false);
        contextMenuItems.set([]);
        fetchNui('hideContextMenu');
    }

    function handleItemClick(item: any) {
        fetchNui('hideUI');
        fetchNui('contextMenuItemClicked', item + 1);
        contextMenuShown.set(false);
        contextMenuItems.set([]);
    }

    function breakDown(text: string): string {
        return text.replace(/\n/g, '<br>') || text;
    }
</script>

{#if $contextMenuShown}
    <div class="menu-container" on:click|self={hideContextMenu}>
        <div class="menu-card">
            <div class="menu-header">
                <div class="header-accent"></div>
                <h3>{$contextMenuItems.name}</h3>
            </div>
            <div class="menu-items-wrapper">
                {#each $contextMenuItems.items as item, index}
                    <div class="menu-item" on:click={() => handleItemClick(index)} style="--delay: {index * 50}ms">
                        {#if item.icon}
                            <div class="icon-container">
                                {#if item.icon.startsWith('fa-')}
                                    <Icon icon={item.icon} classes="menu-icon fa-3x" />
                                {:else}
                                    <img class="menu-icon-img" src={item.icon} alt="{item.title}" />
                                {/if}
                            </div>
                        {/if}
                        <div class="menu-text">
                            <span class="title">{item.title}</span>
                            <span class="description">{@html breakDown(item.description)}</span>
                        </div>
                        <div class="menu-arrow">→</div>
                    </div>
                {/each}
            </div>
        </div>
    </div>
{/if}

<style>
    .menu-container {
        position: fixed;
        top: 50%;
        left: 75%;
        transform: translate(-50%, -50%);
        z-index: 99999;
        width: 25%;
        max-height: 60%;
        font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
        animation: slideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .menu-card {
        background: linear-gradient(145deg, #1a1a1a 0%, #0d1117 100%);
        border: 1px solid rgba(251, 191, 36, 0.1);
        box-shadow: 
            0 4px 12px rgba(0, 0, 0, 0.3),
            0 0 0 1px rgba(251, 191, 36, 0.05),
            inset 0 1px 0 rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        position: relative;
    }

    .menu-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, #FBBF24, transparent);
        opacity: 0.6;
    }

    .menu-header {
        background: linear-gradient(135deg, rgba(251, 191, 36, 0.15) 0%, rgba(251, 191, 36, 0.05) 100%);
        color: #ffffff;
        font-weight: 700;
        font-size: 1.1rem;
        text-align: center;
        padding: 16px 20px;
        border-bottom: 1px solid rgba(251, 191, 36, 0.2);
        position: relative;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }

    .header-accent {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 40px;
        height: 2px;
        background: #FBBF24;
        border-radius: 2px;
    }

    .menu-items-wrapper {
        max-height: calc(60vh - 80px);
        overflow-y: auto;
        padding: 8px 0;
        scrollbar-width: thin;
        scrollbar-color: rgba(251, 191, 36, 0.3) transparent;
    }

    .menu-items-wrapper::-webkit-scrollbar {
        width: 4px;
    }

    .menu-items-wrapper::-webkit-scrollbar-track {
        background: transparent;
    }

    .menu-items-wrapper::-webkit-scrollbar-thumb {
        background: linear-gradient(to bottom, #FBBF24, rgba(251, 191, 36, 0.5));
        border-radius: 4px;
    }

    .menu-item {
        display: flex;
        align-items: center;
        gap: 18px;
        padding: 22px 28px;
        margin: 4px 14px;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        color: #e5e5e5;
        position: relative;
        animation: itemFadeIn 0.4s ease-out forwards;
        animation-delay: var(--delay);
        opacity: 0;
        transform: translateX(-10px);
        border: 1px solid transparent;
        min-height: 68px;
    }

    @keyframes itemFadeIn {
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .menu-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 0;
        background: linear-gradient(135deg, #FBBF24, rgba(251, 191, 36, 0.8));
        border-radius: 10px 0 0 10px;
        transition: width 0.3s ease;
    }

    .menu-item:hover {
        background: linear-gradient(135deg, rgba(251, 191, 36, 0.12) 0%, rgba(251, 191, 36, 0.06) 100%);
        border-color: rgba(251, 191, 36, 0.3);
        transform: translateX(6px) scale(1.02);
        box-shadow: 
            0 2px 8px rgba(251, 191, 36, 0.08),
            inset 0 1px 0 rgba(255, 255, 255, 0.1);
    }

    .menu-item:hover .menu-arrow {
        opacity: 1;
        transform: translateX(0);
        color: #FBBF24;
    }

    .menu-item:hover .icon-container {
        color: #FBBF24;
    }

    .menu-item:active {
        transform: translateX(6px) scale(0.98);
    }

    .menu-icon {
        font-size: 1.1rem;
        color: #cbd5e100;
        transition: color 0.25s ease;
    }

    .menu-icon-img {
        width: 48px;
        height: 48px;
    }


    .menu-text {
        display: flex;
        flex-direction: column;
        flex: 1;
        gap: 2px;
    }

    .title {
        font-size: 1.7rem;
        font-weight: 600;
        color: #ffffff;
        letter-spacing: 0.3px;
        transition: color 0.25s ease;
    }

    .description {
        font-size: 1.4rem;
        color: #9ca3af;
        font-weight: 400;
        transition: color 0.25s ease;
    }

    .menu-item:hover .description {
        color: rgba(251, 191, 36, 0.8);
    }

    .menu-arrow {
        font-size: 1rem;
        color: #6b7280;
        opacity: 0;
        transform: translateX(-8px);
        transition: all 0.25s ease;
        font-weight: bold;
    }
</style>