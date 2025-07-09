<script lang="ts">
    import { showImage, imageUrl } from '../store/showImage';

    let orientation: 'landscape' | 'portrait' | 'square' | null = null;
    let containerStyle = '';

    const sizes = {
        landscape: { width: 900, height: 600 },
        portrait: { width: 600, height: 900 },
        square: { width: 700, height: 700 }
    };

    async function determineOrientation(src: string) {
        return new Promise<'landscape' | 'portrait' | 'square'>((resolve, reject) => {
            const img = new Image();
            img.onload = () => {
                if (img.width > img.height) {
                    resolve('landscape');
                } else if (img.height > img.width) {
                    resolve('portrait');
                } else {
                    resolve('square');
                }
            };
            img.onerror = () => {
                reject(new Error('Failed to load image'));
            };
            img.src = src;
        });
    }

    $: if ($showImage && $imageUrl) {
        orientation = null;

        determineOrientation($imageUrl)
            .then(orient => {
                orientation = orient;
                const { width, height } = sizes[orient];
                containerStyle = `width: ${width}px; height: ${height}px`;
            })
            .catch(err => {
                console.error(err);
                orientation = null;
                containerStyle = '';
            });
    }
</script>

{#if $showImage}
    <div class="modal-overlay" on:click={() => showImage.set(false)}>
        <div class="image-wrapper" style={containerStyle}>
            {#if orientation}
                <img
                    src={$imageUrl}
                    alt="Displayed Image"
                    class="resized-image {orientation}"
                    on:click|stopPropagation
                />
            {:else}
                <div class="loading">Loading...</div>
            {/if}
        </div>
    </div>
{/if}

<style>
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    }

    .image-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
        position: relative;
        border-radius: 12px;
    }

    .resized-image {
        object-fit: contain;
        max-width: 100%;
        max-height: 100%;
        border-radius: 12px;
        transition: opacity 0.3s ease-in-out;
    }

    .resized-image.landscape {
        width: 100%;
        height: auto;
    }

    .resized-image.portrait {
        height: 100%;
        width: auto;
    }

    .resized-image.square {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .loading {
        color: white;
        font-size: 18px;
    }
</style>