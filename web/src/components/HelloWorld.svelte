<script lang="ts">
  import { visibility } from '../store/stores';
  import { fetchNui } from '../utils/fetchNui';
  import { useNuiEvent } from '../utils/useNuiEvent';

  interface ReturnData {
    x: number;
    y: number;
    z: number;
    w: number;
  }

  let coordinates = {
    x: 0,
    y: 0,
    z: 0,
    w: 0,
  };
  let copied = false;
  useNuiEvent<ReturnData>('getCoords', (coords) => {
    console.log('coords', coords);
    coordinates = { ...coords };
  });
  function copyToClipboard(type: string) {
    const el = document.createElement("textarea");
    el.value = type;
    document.body.appendChild(el);
    el.select();
    document.execCommand("copy");
    document.body.removeChild(el);
    copied = true;
    setTimeout(() => {
      copied = false;
    }, 2000);
  }

  function copyCoords(type: string) {
    if (type === 'vec2') {
      const coordString = `vector2(${coordinates.x}, ${coordinates.y})`;
      copyToClipboard(coordString);
    } else if (type === 'vec3') {
      const coordString = `vector3(${coordinates.x}, ${coordinates.y}, ${coordinates.z})`;
      copyToClipboard(coordString);
    } else if (type === 'vec4') {
      const coordString = `vector4(${coordinates.x}, ${coordinates.y}, ${coordinates.z}, ${coordinates.w})`;
    navigator.clipboard.writeText(coordString)
      copyToClipboard(coordString);
    } else if (type === 'stop') {
      closeDialog();
    }
  }
  
  const closeDialog = () => {
    visibility.set(false);
    fetchNui('hideUI');
  };
  
  interface CopyCoordsData {
    type: string;
  }
  
  useNuiEvent<CopyCoordsData>('copyCoords', (data) => {
    copyCoords(data.type);
  });

  window.addEventListener('keydown', (e) => {
    if (e.code === 'Escape') {
      closeDialog();
    }
  });
</script>

<div class="floating-card">
  <div class="header">📍 Grab Coords!</div>
  <div class="coord-box">
    <div class="coord-row"><strong>X:</strong> {coordinates.x}</div>
    <div class="coord-row"><strong>Y:</strong> {coordinates.y}</div>
    <div class="coord-row"><strong>Z:</strong> {coordinates.z}</div>
    <div class="coord-row"><strong>W:</strong> {coordinates.w}</div>
  </div>
  <div class="footer-text">press <kbd>E</kbd> for vec3</div>
  <div class="footer-text">press <kbd>R</kbd> for vec4</div>
  <div class="footer-text">press <kbd>F</kbd> for vec2</div>
  <div class="footer-text">press <kbd>BackSpace</kbd> to close</div>
  {#if copied}
    <div class="footer-text" style = 'color: green;'>Copied to clipboard!</div>
  {/if}
</div>

<style>
  .floating-card {
    position: fixed;
    top: 20px;
    right: 20px;
    width: 10%;
    background-color: #1a1a1a;
    border-radius: 10px;
    padding: 1.5rem;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.6);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: white;
    z-index: 9999;
    animation: slideIn 0.3s ease-out;
  }

  .header {
    font-size: 1.3rem;
    font-weight: bold;
    margin-bottom: 1rem;
    text-align: center;
  }

  .coord-box {
    font-size: 1rem;
    line-height: 1.6;
  }

  .coord-row {
    display: flex;
    justify-content: space-between;
    padding: 0.3rem 0;
    border-bottom: 1px solid #333;
  }

  .coord-row strong {
    color: #cccccc;
  }

  .footer-text {
    margin-top: 0.75rem;
    font-size: 0.85rem;
    color: #aaa;
    text-align: center;
  }

  kbd {
    background: #333;
    padding: 2px 6px;
    border-radius: 4px;
    font-family: monospace;
  }

  @keyframes slideIn {
    from {
      transform: translateX(100px);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @media (max-width: 400px) {
    .floating-card {
      width: 90%;
      right: 10px;
    }
  }
</style>