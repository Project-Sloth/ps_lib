<script lang="ts">
    import { notifications } from './../stores/NotificationStore';
    import { NotificationIcons, NotificationTypes } from './../enums/NotificationTypesEnum';
	
    const getTypeClass = (type: string) => {
		console.log('getTypeClass', type);
        if (type === 'success') {
			return 'ps-notification-success';
		} else if (type === 'warning') {
			return 'ps-notification-warning';
		} else if (type === 'error') {
			return 'ps-notification-error';
		} else if (type === 'info') {
			return 'ps-notification-info';
		} else  {
			return 'ps-notification-info';
		}
    };
</script>

<div class="flex justify-end min-h-screen">
    <div class="flex flex-col mr-4 mt-4 w-[200px]">
        {#each $notifications as notification (notification.id)}
            <div class="{getTypeClass(notification.type)} flex items-center px-4 py-3 mb-1 text-white min-w-full rounded"
            >
                <div class="text-2xl mt-1">
                    {#if notification.type === 'success'}
                        <i class={NotificationIcons.Success} />
                    {:else if notification.type === 'warning'}
                        <i class={NotificationIcons.Warning} />
                    {:else if notification.type === 'error'}
                        <i class={NotificationIcons.Error} />
                    {:else if notification.type === 'info'}
                        <i class={NotificationIcons.Info} />
					{:else}
						<i class={NotificationIcons.Info} />
                    {/if}
                </div>
                <span class="ml-3">{notification.text}</span>
            </div>
        {/each}
    </div>
</div>

