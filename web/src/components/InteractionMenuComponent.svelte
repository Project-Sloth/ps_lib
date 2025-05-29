<script lang="ts">
    import { closeInteractionMenu, menuStore } from "../stores/MenuStores";
    import Icon from "./Icon.svelte";
    import fetchNui from "../../utils/fetch";
    import { isDevMode } from "../stores/GeneralStores";
    import { onMount } from "svelte";
    let menuData:Array<any> = $menuStore;
    let selectedMenuItem = null;
    let subMenu = null;

    let subMenuTextColorOverride = {
        id: null, color: 'black'
    };
    let menuTextColorOverride = {
        id: null, color: 'black'
    };

    function handleMenuSelection(selectedMenu, index) {
        selectedMenuItem = selectedMenu;
        console.log(index)
        if(selectedMenuItem) {
            selectedMenuItem.id = index + 1;
        } else {
            selectedMenuItem = null;
        }
        if(selectedMenu) {
            
            if(!selectedMenu.subMenu && !isDevMode) {
                fetchNui('MenuSelect', {data :selectedMenu});
                closeInteractionMenu();
            } else {
                subMenu = selectedMenuItem.subMenu;
            }
        }
    }

    function handleSubMenuSelection(selectedSubMenu) {
        const formData = {
            data:selectedSubMenu
        };
        if(!isDevMode) {
            fetchNui('MenuSelect', formData);
            closeInteractionMenu();
        }
    }

    function handleItemHover(itemId, index, color, action='enter', isSubMenu = false) {
        const itemDom = document.getElementById(itemId);
        if(action === 'enter') {
            if(isSubMenu) {
                itemDom.style.backgroundColor = color || 'var(--color-green)';
                subMenuTextColorOverride.id = index;
            } else {
                itemDom.style.backgroundColor = color || 'var(--color-green)';
                menuTextColorOverride.id = index;
            }
        } else {
            itemDom.style.backgroundColor = 'var(--color-darkblue)';
            subMenuTextColorOverride.id = null;
            menuTextColorOverride.id = null;
        }
    }
    onMount(() => {
        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closeInteractionMenu();
            }
        });
    });
</script>

<div class="menu-base-wrapper">
    <div class="screen-base">
        {#if !selectedMenuItem}
            <div class="header-slot">
                <h1 style="text-align:center;color: white;">Interaction Menu</h1>
            </div>

            <div class="screen-body">
                {#each menuData as menu, index}
                    <div id={"menu-"+index} class="each-panel" 
                    on:click={() => handleMenuSelection(menu, index)}>
                        <div class="menu-icon">
                        {#if menu.icon} 
                            {#if menu.icon.startsWith('https') || menu.icon.startsWith('nui')}
                                <img src={menu.icon} alt="menu-icon" style="width: 1.5vw; height: 1.5vw;"/>
                            {:else}
                                <Icon icon={menu.icon} styleColor={menuTextColorOverride.id === index ? menuTextColorOverride.color : menu?.color || 'var(--color-green)'} />
                            {/if}
                        {:else}
                            <Icon icon={menu.icon} styleColor={menuTextColorOverride.id === index ? menuTextColorOverride.color : menu?.color || 'var(--color-green)'} />
                        {/if}
                        </div>
                        <div class="menu-details">
                            <p class="header" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-white)'};">{menu.header}</p>
                            {#if menu.hasOwnProperty('text')}
                                <p class="text" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-lightgrey)'};">{menu.text}</p>
                            {/if}
                        </div>
                        {#if menu?.subMenu}
                            <div class="chevron" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-white)'};">
                                <i class="fa-solid fa-chevron-right"></i>
                            </div>
                        {/if}
                    </div>
                {/each}
            </div>
        {:else if selectedMenuItem.hasOwnProperty('subMenu') && selectedMenuItem.subMenu}
            <div class="submenu-header-slot" on:click={() => handleMenuSelection(null)}>
                <i class="fa-solid fa-chevron-left left-chevron"></i>
                <p class="main-menu">Main Menu</p>
            </div>

            <div class="screen-body">
                {#each subMenu as menu, index}
                    <div id={"sub-menu-"+index} class="each-panel" 
                    on:mouseenter={() => handleItemHover("sub-menu-"+index, index, menu.color, 'enter', true)} 
                    on:mouseleave={() => handleItemHover("sub-menu-"+index, index, menu.color, 'leave', true)} 
                    on:click={() => handleSubMenuSelection(menu)}>
                        <div id={"menu-icon-"+index} class="menu-icon">
                            <Icon icon={menu.icon} styleColor={subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : menu.color || 'var(--color-green)'} />
                        </div>
                        <div class="menu-details">
                            <p class="header" style="color: {subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : 'var(--color-white)'};">{menu.header}</p>
                            {#if menu.hasOwnProperty('text')}
                                <p class="text" style="color: {subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : 'var(--color-lightgrey)'};">{menu.text}</p>
                            {/if}
                        </div>
                    </div>
                {/each}
            </div>
        {/if}
    </div>
    
</div>

<style>
    .menu-base-wrapper {
        position: absolute;
        left: 70%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 20vw;
        height: fit-content;
        min-height: 20vw;
        max-height: 80vh;
        background-color: #00000000;
        border-radius: 0.4vw;
        box-shadow: 0 0 0 rgba(0, 0, 0, 0.3);
        overflow: hidden;
        font-family: 'Segoe UI', sans-serif;
        padding: 0.5vw;
    }

    .screen-base {
        display: flex;
        flex-direction: column;
        height: 100%;
    }

    /* Header */
    .header-slot {
        display: flex;
        align-items: center;
        justify-content: space-between;
        text-align: center;
        padding: 0.6vw 1.5vw;
        background-color: rgb(23, 23, 23);
        border-bottom: 0.05vw solid rgb(23, 23, 23);
    }

    .header-slot img {
        height: 2.5vw;
    }

    /* Submenu Header */
    .submenu-header-slot {
        display: flex;
        align-items: center;
        padding: 0.6vw 1vw;
        background-color: rgb(23, 23, 23);
        color: var(--color-white);
        cursor: pointer;
        transition: background-color 0.2s ease;
    }

    .submenu-header-slot:hover {
        background-color: rgba(255, 255, 255, 0.08);
        color: black;
    }

    .left-chevron {
        margin-right: 0.5vw;
        font-size: 1.1vw;
    }

    .main-menu {
        font-size: 1.1vw;
        font-weight: 600;
    }

    /* Body */
    .screen-body {
        flex: 1;
        padding: 0.5vw 0;
        overflow-y: auto;
    }

    .screen-body::-webkit-scrollbar {
        display: none;
    }

    /* Menu Item Panel */
    .each-panel {
        display: flex;
        align-items: center;
        padding: 5% 0 5% 1.5vw;
        margin-bottom: 0.4vw;
        background-color: rgb(23, 23, 23);
        border-radius: 0.3vw;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .each-panel:hover {
        background-color: #FBBF24;
        transform: translateX(0.2vw);
        color: black;
    }

    .menu-icon {
        font-size: 1.1vw;
        margin-right: 0.7vw;
    }

    .menu-details {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .menu-details .header {
        font-size: 0.9vw;
        font-weight: 500;
        color: var(--color-white);
        white-space: nowrap;
    }

    .menu-details .text {
        font-size: 0.7vw;
        color: black;
        white-space: nowrap;
    }

    .chevron {
        font-size: 1vw;
        color: var(--color-lightgrey);
        margin-left: auto;
        transition: transform 0.2s ease;
    }

    .each-panel:hover .chevron {
        transform: translateX(0.3vw);
        color: var(--color-white);
    }
</style>