<script lang="ts">
  import { isDrawText, drawText } from '../store/DrawText';
</script>

{#if $isDrawText === true}
  <div class="text-display">
    <p>{$drawText}</p>
  </div>
{/if}

<style>
  .text-display {
    position: fixed;
    top: 50%;
    left: 20px;
    transform: translateY(-50%);
    color: #e5e5e5;
    font-size: 18px;
    font-weight: 500;
    z-index: 1000;
    width: max-content;
    max-width: 400px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
    border: 1px solid #FBBF24;
    border-radius: 12px;
  }

  .text-display p {
    margin: 0;
    padding: 14px 18px;
    background: linear-gradient(135deg, #1e1e1e 0%, #2a2a2a 100%);
    border-radius: 12px;
    color: #d1d5db;
    line-height: 1.5;
    letter-spacing: -0.01em;
    word-wrap: break-word;
  }
</style>