<script lang="ts">
    import { fetchNui } from '../utils/fetchNui';
    import { craftingRecipes, craftingShown } from '../store/craftingStore';
    import { onMount } from 'svelte';
    let selectedItem:any = $craftingRecipes[0] || null;
    let selectedItemName:string = '';

    function updateSelectedItem(recipe: any) {
        selectedItem = recipe;
        selectedItemName = recipe.result.name;
    }
    function sendCraft() {
        fetchNui('hideUI');
        fetchNui('craftItem', {
            item: selectedItem.result.name,
            time: selectedItem.result.Time,
            anim: selectedItem.result.anim || 'amb@prop_human_bum_bin@base',
            minigame: selectedItem.minigame || null,
        })
        craftingRecipes.set([]);
        craftingShown.set(false);
    }

    onMount(() => {
        if ($craftingRecipes.length > 0) {
            selectedItem = $craftingRecipes[0];
        }
    }); 
</script>


{#if $craftingShown}
    <div class="container">
        <div class="preview-grid">
            {#if $craftingRecipes.length > 0}
                {#each $craftingRecipes as recipe}
                    <div
                        class="recipe-cell{selectedItem === recipe ? ' active' : ''}"
                        on:click={() => updateSelectedItem(recipe)}
                    >
                        <img src={recipe.result.image} alt={recipe.result.name} />
                        <span class="recipe-name">{recipe.result.Label || recipe.result.name}</span>
                    </div>
                {/each}
            {:else}
                <div class="empty-state">No recipes available.</div>
            {/if}
        </div>

        <div class="details-panel">
            {#if selectedItem}
                <div>
                    <div class="details-header">
                        <img src={selectedItem.result.image} alt={selectedItem.result.name} />
                        <h2>{selectedItem.result.Label || selectedItem.result.name}</h2>
                    </div>

                    <h3>Ingredients:</h3>
                    <ul>
                        {#each selectedItem.recipe as item}
                            <li>
                                <img src={item.image} alt={item.name} />
                                {item.name} x{item.amount}
                            </li>
                        {/each}
                    </ul>

                    <p class="craft-time">
                        Craft Time: {Math.floor(selectedItem.result.Time / 1000)} seconds
                    </p>
                    {#if selectedItem.canCraft}
                        <button class="btn-primary" on:click={() => sendCraft()}>
                            Start Crafting
                        </button>
                    {:else}
                        <button class="btn-primary" style="background: rgb(20, 20, 20); color: white;" disabled>
                            Missing Ingredients
                        </button>
                    {/if}
                </div>
            {:else}
                <p>Select a recipe to view details.</p>
            {/if}
        </div>
    </div>
{/if}

<style>
    :global(body) {
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: white;
}

.container {
    position: fixed;
    top: 50%;
    right: 10%;
    transform: translateY(-50%);
    max-width: 40vw;
    width: 30%;
    border-radius: 16px;
    overflow: hidden;
    background: rgb(40, 40, 40);
    border: 1px solid rgba(251, 189, 36, 0.2);
    display: flex;
    flex-direction: row;
    height: 70vh;
    z-index: 9999;
}

.preview-grid {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 16px;
    overflow-y: auto;
    width: 30%;
    border-right: 1px solid rgba(251, 189, 36, 0.15);
    background-color: rgb(40, 40, 40);
}

.preview-grid::-webkit-scrollbar,
.details-panel::-webkit-scrollbar {
    display: none;
}

.recipe-cell {
    background-color: rgb(45, 45, 45);
    border: 1px solid rgba(251, 189, 36, 0.2);
    border-radius: 12px;
    padding: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 8px;
}

.recipe-cell img {
    width: 64px;
    height: 64px;
    border-radius: 4px;
}

.recipe-name {
    font-size: 14px;
    font-weight: 500;
}

.recipe-cell:hover,
.recipe-cell.active {
    background-color: rgba(251, 189, 36, 0.15);
    border-color: #FBBF24;
    transform: scale(1.02);
}

.details-panel {
    flex: 1;
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    overflow-y: auto;
    background-color: rgba(35, 35, 35, 0.6);
}

.details-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
}

.details-header img {
    width: 64px;
    height: 64px;
    border-radius: 8px;
}

.details-header h2 {
    margin: 0;
    font-size: 22px;
    font-weight: 600;
    color: #FBBF24;
    letter-spacing: 0.5px;
}

ul {
    list-style: none;
    padding-left: 0;
    margin: 0;
}

li {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 6px;
}

li img {
    width: 48px;
    height: 48px;
    border-radius: 4px;
}

.craft-time {
    font-size: 14px;
    color: #ccc;
    margin-top: 16px;
}

/* Secondary Color Accent */
.btn-primary {
    background: linear-gradient(to right, #fbbf24, #f59e0b);
    color: black;
    font-weight: bold;
    padding: 10px 16px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    align-self: flex-start;
}

.btn-primary:hover {
    transform: scale(1.03);
}
</style>