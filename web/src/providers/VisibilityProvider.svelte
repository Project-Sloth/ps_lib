<script lang="ts">
  import { useNuiEvent } from '../utils/useNuiEvent';
  import { fetchNui } from '../utils/fetchNui';
  import { onMount } from 'svelte';
  // STORES //
  import { pushNotification } from '../utils/NotificationQueue';
  import { craftingShown, craftingRecipes } from '../store/craftingStore';
  import { contextMenuShown, contextMenuItems } from '../store/ContextMenu';
  import {isCoordGrabbing, coordGrabberCoords} from '../store/coordGrabber';
  import { isInputting, inputData, inputFormName } from '../store/InputStore';
  import { showImage, imageUrl } from '../store/showImage';
  import { isDrawText, drawText } from '../store/DrawText';
  import { initializeCircleGame, setupCircleGame } from '../store/CircleGameStore';
  import { numActive, numSettings } from '../store/NumberMaze';
  import { varActive, varSettings } from '../store/VarGame';
  import { scramblerActive, scramblerSettings } from '../store/ScramblerGame';
  import { thermActive, thermSettings } from '../store/ThermiteGame';
  // PAGES //
  import Notify from '../components/Notify.svelte';
  import Crafting from '../components/Crafting.svelte';
  import ContextMenu from '../components/ContextMenu.svelte';
  import CoordGrabber from '../components/CoordGrabber.svelte';
  import Input from '../components/Input.svelte';
  import ShowImage from '../components/ShowImage.svelte';
  import DrawText from '../components/DrawText.svelte';
  import CircleGame from '../components/CircleGame.svelte';
  import NumberMaze from '../components/NumberMaze.svelte';
  import VarGame from '../components/VarGame.svelte';
  import ScramblerGame from '../components/ScramblerGame.svelte';
  import ThermiteGame from '../components/ThermiteGame.svelte';

  useNuiEvent<{
    message: string;
    type: 'success' | 'error' | 'warning' | 'info';
    duration?: number;
  }>('notify', (data) => {
    pushNotification(data);
  });

  useNuiEvent('setCrafting', (crafting: any) => {
    craftingRecipes.set(crafting);
    craftingShown.set(true);
  });
  
  useNuiEvent('openContextMenu', (data) => {
    contextMenuShown.set(true);
    contextMenuItems.set(data);
  });

  useNuiEvent('coordGrabber', (bool) => {
    isCoordGrabbing.set(bool);
    coordGrabberCoords.set({ x: 2, y: 40, z: 50, w: 0 });
  });
  
  useNuiEvent('updateCoords', (data) => {
    coordGrabberCoords.set(data);
  });

  useNuiEvent('openInput', (data) => {
    isInputting.set(true);
    inputData.set(data.items);
    inputFormName.set(data.name);
  });

  useNuiEvent('showImage', (data) => {
    showImage.set(true);
    imageUrl.set(data);
  });

  useNuiEvent('drawText', (data) => {
    isDrawText.set(true);
    drawText.set(data);
  });

  useNuiEvent('hideDrawText', () => {
    isDrawText.set(false);
    drawText.set('');
  });
  useNuiEvent('CircleGame', (data) => {
    initializeCircleGame();
    setupCircleGame(data);
  });
  useNuiEvent('NumberMaze', (data) => {
    numActive.set(true);
    numSettings.set(data);
  });

  useNuiEvent('VarGame', (data) => {
    varActive.set(true);
    varSettings.set(data);
  });

  useNuiEvent('Scrambler', (data) => {
    scramblerActive.set(true);
    scramblerSettings.set(data);
  });
  useNuiEvent('ThermiteGame', (data) => {
    thermActive.set(true);
    thermSettings.set(data);
  });

  function copyToClipboards(str) {
      const el = document.createElement("textarea");
      el.value = str;
      document.body.appendChild(el);
      el.select();
      document.execCommand("copy");
      document.body.removeChild(el);
      let copied = true;
      setTimeout(() => {
          copied = false;
      }, 2000);
  }

  useNuiEvent('copyClipboard', (data) => {
      copyToClipboards(data);
  });

  useNuiEvent('hideContext', () => {
    contextMenuShown.set(false);
    contextMenuItems.set([]);
  });
  
  function hideUI() {
    fetchNui('hideUI');
    craftingRecipes.set([]);
    craftingShown.set(false);
    contextMenuShown.set(false);
    contextMenuItems.set([]);
    isCoordGrabbing.set(false);
    coordGrabberCoords.set({});
    showImage.set(false);
    imageUrl.set('');
    isDrawText.set(false);
    drawText.set('');
  }


  onMount(() => {
      window.addEventListener('keydown', (e: KeyboardEvent) => {
      if (['Escape'].includes(e.code)) {
        hideUI();
      }
    });
  });
</script>

<main>
  {#if $craftingShown === true}
    <Crafting />
  {/if}
  {#if $contextMenuShown === true}
    <ContextMenu />
  {/if}
  {#if $isCoordGrabbing === true}
    <CoordGrabber />
  {/if}
  {#if $isInputting === true}
    <Input />
  {/if}
  {#if $showImage === true}
    <ShowImage />
  {/if}
  {#if $isDrawText === true}
    <DrawText />
  {/if}
  {#if $numActive === true}
    <NumberMaze />
  {/if}
  {#if $varActive === true}
    <VarGame />
  {/if}
  {#if $scramblerActive === true}
    <ScramblerGame />
  {/if}
  {#if $thermActive === true}
    <ThermiteGame />
  {/if}
  <Notify />
</main>