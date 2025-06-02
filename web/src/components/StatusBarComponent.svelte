<script lang="ts">
    import { hideStatusBar, hideStatusBarStore, statusBarStore } from "../stores/StatusBarStores";
    import { onMount } from "svelte";
    import { isDevMode, showComponent, showUi } from "../stores/GeneralStores";

    let statusData:any = $statusBarStore;
    statusBarStore.subscribe((value) => {
        statusData = value;
    });

    let hideStatusBarValue = false;
    hideStatusBarStore.subscribe(value => {
        hideStatusBarValue = value;
    });
    let coords = {
        x: 100.0,
        y: 200.0,
        z: 35.00,
        w: 180.0
    };
    const copyToClipboard = (str) => {
        const el = document.createElement("textarea");
        el.value = str;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
    };
    let notify = false
    function copyCoords(type, strings) {
        if(type === 'vec3') {
            copyToClipboard(`vector3(${coords.x}, ${coords.y}, ${coords.z})`);
            notify = true;
            setTimeout(() => {
                notify = false;
            }, 1000);
            return;
        }
        if(type === 'vec4') {
            copyToClipboard(`vector4(${coords.x}, ${coords.y}, ${coords.z}, ${coords.w})`);
            notify = true;
            setTimeout(() => {
                notify = false;
            }, 1000);
            
            return;
        }
        if(type === 'vec2') {
            copyToClipboard(`vector2(${coords.x}, ${coords.y})`);
            notify = true;
            setTimeout(() => {
                notify = false;
            }, 1000);
            return;
        }
        if(type === 'copy') {
            copyToClipboard(strings);
            notify = true;
            setTimeout(() => {
                notify = false;
            }, 1000);
            return;
        }
        if(type === 'stop') {
            closeStatusBar();
            return;
        }

    }
    
    onMount(() => {
        window.addEventListener('message', (event) => {
            if(event.data && event.data.action === 'updateCoords') {
    
                coords.x = event.data.data.x.toFixed(2);
                coords.y = event.data.data.y.toFixed(2);
                coords.z = event.data.data.z.toFixed(2);
                coords.w = event.data.data.w.toFixed(2);
            }
        });
        window.addEventListener('message', (event) => {
            if(event.data && event.data.action === 'copyCoords') {
                copyCoords(event.data.data.type, event.data.data.string  || '');
            }
        });
    });

    function closeStatusBar() {
            setTimeout(() => {
                showUi.set(false);
                showComponent.set(null);
                
                statusBarStore.set({
                    title: '',
                    description: '',
                    items: [],
                    icon: '',
                });
                hideStatusBarStore.set(false);
            }, 100);
        }
    

    $: {
        if(hideStatusBarValue) {
            closeStatusBar();
        }
    }
</script>

<div class="coordGrab { notify ? 'expanded' : '' }">
    <div class="coordGrab-header">
        <p>Coord Grabber</p>
    </div>
    <div class="coordGrab-data">
        <p>X: <span id="x">{coords.x}</span></p>
        <p>Y: <span id="y">{coords.y}</span></p>
        <p>Z: <span id="z">{coords.z}</span></p>
        <p>Heading: <span id="w">{coords.w}</span></p>
    </div>

    {#if notify}
        <div class="notification-box">
            <p>You Copied Coords!</p>
        </div>
    {/if}

    <div class="line"></div>
    <div class="instructions">
        <p>Press <span class="key">E</span> for vector3.</p>
        <p>Press <span class="key">R</span> for vector4.</p>
        <p>Press <span class="key">F</span> for vector2.</p>
        <p>Press <span class="key">Mouse Right Click</span> To Quit</p>
    </div>
</div>
<style>
.coordGrab {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 18%;
    max-width: 320px;
    background: rgba(30, 30, 30, 0.9);
    color: white;
    font-family: 'Inter', sans-serif, Arial;
    border-radius: 12px;
    padding: 16px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    gap: 10px;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    transition: all 0.3s ease;
    overflow: hidden;
    height: auto;
    max-height: 300px;
}

.coordGrab.expanded {
    padding-bottom: 8px;
    max-height: 400px;
}

.coordGrab-header {
    text-align: center;
    font-size: 18px;
    font-weight: 600;
    color: #ffffff;
    letter-spacing: 0.5px;
    padding-bottom: 6px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.15);
}
.notification-box {
   color: green;
   text-align: center;
   width: 100%;
}

.coordGrab-data {
    background-color: rgba(255, 255, 255, 0.05);
    padding: 12px 14px;
    border-radius: 8px;
    font-size: 14px;
    line-height: 1.7;
    border: 1px solid rgba(255, 255, 255, 0.08);
}

.coordGrab-data p {
    margin: 0;
    color: #e0e0e0;
    transition: color 0.2s ease;
}

.line {
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    margin: 10px 0;
}

.instructions {
    font-size: 12px;
    color: #aaa;
    text-align: center;
    margin-top: 6px;
    font-style: italic;
}
</style>