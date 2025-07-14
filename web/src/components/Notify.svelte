<script lang="ts">
  import { notifications, type NotificationType } from '../store/notificationsStore';
  import Icon from "./Icons.svelte";
  const icons: Record<NotificationType, { img: string; color: string }> = {
    info: { img: 'fa-solid fa-circle-info', color: '#3b82f6' },
    success: { img: 'fa-solid fa-circle-check', color: '#10b981' },
    error: { img: 'fa-solid fa-circle-exclamation', color: '#ef4444' },
    warning: { img: 'fa-solid fa-triangle-exclamation', color: '#f59e0b' }
  };
  function breakDown(text: string): string {
    return text.replace(/\n/g, '<br>') || text;
    }
</script>

{#if $notifications.length > 0}
  <div class="toast-wrapper">
    {#each $notifications as notif (notif.id)}
      <div class="toast {notif.type}">
        <span class="emoji">
          <Icon icon={icons[notif.type].img} classes="emoji" styleColor={icons[notif.type].color} />
        </span>
        <span class="text">{@html breakDown(notif.message)}</span>
      </div>
    {/each}
  </div>
{/if}

<style>
  .toast-wrapper {
    position: fixed;
    top: 20px;
    right: 20px;
    max-width: 300px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    gap: 12px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  }

  .toast {
    display: flex;
    align-items: flex-start;
    padding: 16px 18px;
    border-radius: 12px;
    background: linear-gradient(135deg, #1e1e1e 0%, #2a2a2a 100%);
    border: 1px solid #3a3a3a;
    color: #e5e5e5;
    animation: slideIn 0.4s cubic-bezier(0.23, 1, 0.32, 1) forwards;
    transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
    cursor: pointer;
    min-width: 300px;
    max-width: 300px;
    box-sizing: border-box;
    word-wrap: break-word;
    position: relative;
    overflow: hidden;
  }

  .toast::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 2px;
    transition: opacity 0.3s ease;
  }

  .toast:hover {
    transform: translateX(-8px) translateY(-2px);
    border-color: #4a4a4a;
    box-shadow: 
      0 12px 40px rgba(0, 0, 0, 0.5),
      0 1px 0 rgba(255, 255, 255, 0.08) inset;
  }

  .toast.success::before { 
    background: linear-gradient(90deg, #10b981, #059669);
    opacity: 0.8;
  }
  .toast.error::before { 
    background: linear-gradient(90deg, #ef4444, #dc2626);
    opacity: 0.8;
  }
  .toast.warning::before { 
    background: linear-gradient(90deg, #f59e0b, #d97706);
    opacity: 0.8;
  }
  .toast.info::before { 
    background: linear-gradient(90deg, #3b82f6, #2563eb);
    opacity: 0.8;
  }

  .toast.success:hover::before { opacity: 1; }
  .toast.error:hover::before { opacity: 1; }
  .toast.warning:hover::before { opacity: 1; }
  .toast.info:hover::before { opacity: 1; }

  .emoji {
    font-size: 1.8rem;
    margin-right: 12px;
    flex-shrink: 0;
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
    opacity: 0.9;
  }

  .text {
    font-size: 14px;
    font-weight: 400;
    flex-grow: 1;
    color: #d1d5db;
    white-space: normal;
    overflow-wrap: break-word;
    hyphens: auto;
    line-height: 1.5;
    letter-spacing: -0.01em;
  }

  @keyframes slideIn {
    from {
      transform: translateX(120px) scale(0.95);
      opacity: 0;
    }
    to {
      transform: translateX(0) scale(1);
      opacity: 1;
    }
  }
</style>