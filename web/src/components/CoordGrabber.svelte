<script lang="ts">
    import { fetchNui } from '../utils/fetchNui';
    import { isCoordGrabbing, coordGrabberCoords } from '../store/coordGrabber';
    import { useNuiEvent } from '../utils/useNuiEvent';

    let copied = false;
    function copyToClipboards(str) {
        const el = document.createElement("textarea");
        el.value = str;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
        copied = true;
        setTimeout(() => {
            copied = false;
        }, 2000);
    }
    useNuiEvent<any>('copyCoords', (data) => {
       if (data.type === 'vec3') {
           const coordString = `vector3(${$coordGrabberCoords.x.toFixed(2)}, ${$coordGrabberCoords.y.toFixed(2)}, ${$coordGrabberCoords.z.toFixed(2)})`;
           copyToClipboards(coordString);
        }
        if (data.type === 'vec4') {
              const coordString = `vector4(${$coordGrabberCoords.x.toFixed(2)}, ${$coordGrabberCoords.y.toFixed(2)}, ${$coordGrabberCoords.z.toFixed(2)}, ${$coordGrabberCoords.w.toFixed(2)})`;
              copyToClipboards(coordString);
        }
        if (data.type === 'vec2') {
            const coordString = `vector2(${$coordGrabberCoords.x.toFixed(2)}, ${$coordGrabberCoords.y.toFixed(2)})`;
            copyToClipboards(coordString);
        }
        if (data.type === 'stop') {
            fetchNui('hideUI');
            isCoordGrabbing.set(false);
            coordGrabberCoords.set({ x: 0, y: 0, z: 0, w: 0 });
        }
    });
</script>

{#if $isCoordGrabbing}
    <div class="coord-grabber">
        <div class="coord-display">
            <span>X: {$coordGrabberCoords.x.toFixed(2)}</span>
            <span>Y: {$coordGrabberCoords.y.toFixed(2)}</span>
            <span>Z: {$coordGrabberCoords.z.toFixed(2)}</span>
            <span>W: {$coordGrabberCoords.w.toFixed(2)}</span>
        </div>
        <div class="instructions">
            <span>Click <span class="key">E</span> for Vector3</span>
            <span>Click <span class="key">R</span> for Vector4</span>
            <span>Click <span class="key">F</span> for Vector2</span>
            <span>Right Click Mouse To Exit</span>
            {#if copied}
                <span style = "color: green;">Copied to clipboard!</span>
            {/if}
        </div>
    </div>
{/if}

<style>

.coord-grabber {
    position: fixed;
    top: 20px;
    left: 40px;
    z-index: 10000;
    background: linear-gradient(135deg, #0f0f0f 0%, #1a1a1a 50%, #111111 100%);
    color: #e5e7eb;
    padding: 1.5rem;
    border-radius: 16px;
    font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
    border: 1px solid #262626;
    min-width: 280px;
    
    position: relative;
    overflow: hidden;
    width: 20%;
}

.coord-grabber::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at 50% 0%, rgba(251, 191, 36, 0.08) 0%, transparent 50%);
    pointer-events: none;
}

.coord-grabber::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, #FBBF24 50%, transparent 100%);
    opacity: 0.6;
}

.coord-display {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-bottom: 1rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #333333;
    position: relative;
    z-index: 1;
}

.coord-display::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, rgba(251, 191, 36, 0.3) 50%, transparent 100%);
}

.coord-display span {
    font-size: 0.95rem;
    font-weight: 600;
    color: #f8fafc;
    padding: 0.5rem 0.75rem;
    background: linear-gradient(135deg, #262626 0%, #1a1a1a 100%);
    border: 1px solid #333333;
    border-radius: 8px;
    display: flex;
    align-items: center;
    position: relative;
    overflow: hidden;
    letter-spacing: 0.025em;
    transition: all 0.3s ease;
}

.coord-display span::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.05) 0%, transparent 50%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.coord-display span:hover::before {
    opacity: 1;
}

.coord-display span:hover {
    border-color: rgba(251, 191, 36, 0.3);
    box-shadow: 0 0 12px rgba(251, 191, 36, 0.1);
    transform: translateY(-1px);
}

.instructions {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: #cbd5e1;
    position: relative;
    z-index: 1;
}

.instructions > span {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 0;
    font-weight: 500;
    letter-spacing: 0.025em;
    transition: color 0.3s ease;
}

.instructions > span:hover {
    color: #f1f5f9;
}

.key {
    color: #0f0f0f;
    font-weight: 700;
    background: linear-gradient(135deg, #FBBF24 0%, #f59e0b 100%);
    padding: 0.375rem 0.75rem;
    border-radius: 6px;
    font-size: 0.8rem;
    min-width: 1.5rem;
    text-align: center;
    box-shadow: 
        0 2px 4px rgba(251, 191, 36, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(251, 191, 36, 0.3);
    position: relative;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.key::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.key:hover::before {
    opacity: 1;
}

.key:hover {
    transform: translateY(-1px) scale(1.05);
    box-shadow: 
        0 4px 8px rgba(251, 191, 36, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.instructions span[style*="color: green"] {
    color: #22c55e !important;
    font-weight: 600;
    background: linear-gradient(135deg, rgba(34, 197, 94, 0.1) 0%, transparent 50%);
    border: 1px solid rgba(34, 197, 94, 0.2);
    border-radius: 8px;
    padding: 0.5rem 0.75rem;
    text-shadow: 0 0 8px rgba(34, 197, 94, 0.3);
    animation: fadeInScale 0.3s ease-out;
}

@keyframes fadeInScale {
    from {
        opacity: 0;
        transform: translateY(10px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@media (max-width: 768px) {
    .coord-grabber {
        top: 15px;
        right: 15px;
        left: 15px;
        min-width: auto;
        padding: 1.25rem;
    }
    
    .coord-display span {
        font-size: 0.9rem;
        padding: 0.4rem 0.6rem;
    }
    
    .instructions {
        font-size: 0.8rem;
    }
    
    .key {
        font-size: 0.75rem;
        padding: 0.3rem 0.6rem;
    }
}

@media (max-width: 480px) {
    .coord-grabber {
        top: 10px;
        right: 10px;
        left: 10px;
        padding: 1rem;
    }
    
    .coord-display {
        gap: 0.375rem;
        margin-bottom: 0.75rem;
        padding-bottom: 0.75rem;
    }
    
    .instructions {
        gap: 0.375rem;
    }
}
</style>