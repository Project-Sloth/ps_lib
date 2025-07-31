<script lang="ts">
    import fetchNui from "../../utils/fetch";
    import { onMount } from "svelte";
    import {numActive, numSettings} from '../store/NumberMaze';

    let gameTimeRemaining = 0;

    let gameTime = $numSettings.gameTime * 100 + 300;
    let numberOfWrongClicksAllowed = $numSettings.maxAnswersIncorrect;

    let counter, gameStarted = false, gameEnded = false;
    let numberOfCubes = 49, allCubes = [];
    let blinkingIndex, correctRoute = [], goodPositions = [], stopBlinking = false;
    let lastPos = 0, wrongAnswerCount = 0;
    let displayCubeNumbers = false;

    onMount(() => {
        blinkingIndex = Math.floor(Math.random() * (4 - 1) + 1);
        correctRoute = generateBestRoute(blinkingIndex);
        
        goodPositions = Object.keys(correctRoute);
        for(let i = 0; i < numberOfCubes; i++) {
            const cubeValue = [blinkingIndex, blinkingIndex * 7].includes(i) ? Math.floor(Math.random() * (4 - 1) + 1) : Math.floor(Math.random() * (5 - 1) + 1);
            
            const cubeData = {
                cubeIndex: i,
                cubeValue: goodPositions.includes(i.toLocaleString()) ? correctRoute[i] : cubeValue,
                classList: ''
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, 1000);

    });

    function maxVertical(pos) {
        return Math.floor((48-pos)/7);
    }

    function maxHorizontal(pos) {
        let max = (pos+1) % 7;
        if(max > 0) return 7-max;
            else return 0;
    }

    function generateNextPosition(pos) {
        let maxV = maxVertical(pos);
        let maxH = maxHorizontal(pos);
        if(maxV === 0 ){
            let new_pos = Math.floor(Math.random() * (maxH - 1) + 1);
            return [new_pos, pos+new_pos];
        }
        if(maxH === 0 ){
            let new_pos = Math.floor(Math.random() * (maxV - 1) + 1);
            return [new_pos, pos+(new_pos*7)];
        }
        if(Math.floor(Math.random() * 1000 + 1) % 2 === 0 ){
            let new_pos = Math.floor(Math.random() * (maxH - 1) + 1);
            return [new_pos, pos+new_pos];
        } else {
            let new_pos = Math.floor(Math.random() * (maxV - 1) + 1);
            return [new_pos, pos+(new_pos*7)];
        }
    }

    function generateBestRoute(start_pos) {
        let route = [];
        if(Math.floor(Math.random() * 1000 + 1) % 2 === 0 ){
            start_pos *= 7;
        }
        while(start_pos < 48){
            let new_pos = generateNextPosition(start_pos);
            route[start_pos] = new_pos[0];
            start_pos = new_pos[1];
        }
        
        return route;
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            wrongAnswerCount = numberOfWrongClicksAllowed;
            checkMazeAnswer();
            return;
         } 
         gameTime--;
         gameTimeRemaining = gameTime/100;
    }

    function updateAllCubesArrayWithClassListOfClickedCube(isGood, clickedCube) {
        const additionClassString = isGood ? ' ps-bg-green-cube' : ' ps-bg-wrong-cube';
        const newClassList = clickedCube.classList + additionClassString;
        clickedCube.classList = newClassList;
        allCubes[clickedCube.cubeIndex] = clickedCube;
        allCubes = allCubes;
    }

    
    function handleCubeClick(clickedCube) {
        if(!gameEnded && clickedCube.cubeIndex !== 0) {
            let posClicked = clickedCube.cubeIndex;
            if(lastPos === 0) {
                stopBlinking = true;
                if([blinkingIndex, blinkingIndex * 7].includes(posClicked)) {
                    lastPos = posClicked;
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else {
                    wrongAnswerCount++;
                    updateAllCubesArrayWithClassListOfClickedCube(false, clickedCube);
                }
            } else {
                let posJumps = allCubes[lastPos].cubeValue;
                let maxV = maxVertical(lastPos);
                let maxH = maxHorizontal(lastPos);

                if(posJumps <= maxH && posClicked === lastPos + posJumps) {
                    lastPos = posClicked;
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else if (posJumps <= maxV && posClicked === lastPos + (posJumps * 7)) {
                    lastPos = posClicked;
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else {
                    wrongAnswerCount++;
                    updateAllCubesArrayWithClassListOfClickedCube(false, clickedCube);
                }
            }
        }

        checkMazeAnswer();
    }

    function checkMazeAnswer() {
        if(wrongAnswerCount === numberOfWrongClicksAllowed) {
            clearInterval(counter);
            
            displayCubeNumbers = true;

            allCubes = allCubes.map((cube) => {
                cube.classList = goodPositions.includes(cube.cubeIndex.toLocaleString()) ? 'ps-bg-green-cube' : '';
                return cube;
            });
            allCubes = allCubes;

            setTimeout(() => {
                gameEnded = true;
                fetchNui('maze-result', false);
                fetchNui('hideUI');
                numActive.set(false);
                numSettings.set({});
            }, 3000);

            return;
        } else if(lastPos === 48){
            clearInterval(counter);
            
            displayCubeNumbers = true;

            setTimeout(() => {
                gameEnded = true;
                fetchNui('maze-result', true);
                fetchNui('hideUI');
                numActive.set(false);
                numSettings.set({});
            }, 3000);
        }
    }
    onMount(() => {
        window.addEventListener('keydown', (e: KeyboardEvent) => {
            if (['Escape'].includes(e.code)) {
                fetchNui('maze-result', false);
                fetchNui('hideUI');
                numActive.set(false);
                numSettings.set({});
            }
        });
    });
</script>

{#if $numActive}
    <div class="game-wrapper">
        <div class="maze-game-base">
            <div class="time-left">
                <i class="fa-solid fa-clock clock-icon"></i>
                <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining}</p>
                time remaining
            </div>

            <div id="maze-game-container" class="maze-game-container">
                {#each allCubes as cube}
                    <div 
                        id={'cube-' + cube.cubeIndex} 
                        on:click={() => handleCubeClick(cube)}
                        class="each-cube {cube.classList}
                            {[0, numberOfCubes - 1].includes(cube.cubeIndex) ? 'start-dest-cube' : ''} 
                            {!stopBlinking && [blinkingIndex, blinkingIndex * 7].includes(cube.cubeIndex) ? 'blinking-cube' : ''}
                        "
                    >
                        {#if cube.cubeIndex === 0}
                            <i class="fa-solid fa-ethernet icon-start"></i>
                        {:else if cube.cubeIndex === numberOfCubes - 1}
                            <i class="fa-solid fa-network-wired icon-end"></i>
                        {:else if !stopBlinking || displayCubeNumbers}
                            <span class="cube-number">{cube.cubeValue}</span>
                        {/if}
                    </div>
                {/each}
            </div>
        </div>
    </div>
{/if}
<style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0a0a0a;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
        }

        .game-wrapper {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            border-radius: 20px;
            padding: 2rem;
            max-width: 500px;
            width: 90vw;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 10;
        }

        .game-wrapper::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(251, 191, 36, 0.05) 0%, transparent 50%);
            border-radius: 20px;
            pointer-events: none;
        }

        .maze-game-base {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #ffffff;
            position: relative;
            z-index: 1;
        }

        .time-left {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            margin-bottom: 1.5rem;
            gap: 0.5rem;
            background: rgba(0, 0, 0, 0.4);
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            border: 1px solid rgba(251, 191, 36, 0.2);
            backdrop-filter: blur(10px);
        }

        .clock-icon {
            font-size: 1.2rem;
            color: #FBBF24;
            filter: drop-shadow(0 0 4px rgba(251, 191, 36, 0.4));
        }

        .game-timer-var {
            min-width: 3rem;
            text-align: center;
            font-weight: 700;
            color: #FBBF24;
            font-size: 1.1rem;
            text-shadow: 0 0 8px rgba(251, 191, 36, 0.3);
        }

        .maze-game-container {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.5rem;
            width: 100%;
            max-width: 420px;
            padding: 1rem;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 16px;
            border: 1px solid rgba(251, 191, 36, 0.1);
        }

        .each-cube {
            aspect-ratio: 1;
            width: 100%;
            min-height: 50px;
            background: linear-gradient(135deg, #2a2a2a 0%, #1e1e1e 100%);
            border: 2px solid rgba(251, 191, 36, 0.3);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.2rem;
            user-select: none;
            position: relative;
            overflow: hidden;
        }

        .each-cube::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(251, 191, 36, 0.1) 0%, transparent 50%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .each-cube:hover::before {
            opacity: 1;
        }

        .each-cube:hover {
            transform: translateY(-2px);
            border-color: #FBBF24;
            box-shadow: 
                0 8px 16px rgba(0, 0, 0, 0.3),
                0 0 20px rgba(251, 191, 36, 0.2);
        }

        .start-dest-cube {
            background: linear-gradient(135deg, #FBBF24 0%, #f59e0b 100%);
            color: #0a0a0a;
            font-size: 1.4rem;
            border: 2px solid #FBBF24;
            box-shadow: 
                0 4px 12px rgba(251, 191, 36, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
            font-weight: 700;
        }

        .start-dest-cube:hover {
            box-shadow: 
                0 8px 20px rgba(251, 191, 36, 0.4),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
        }

        .start-dest-cube i {
            vertical-align: middle;
            filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.3));
        }

        .cube-number {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
        }

        .blinking-cube {
            animation: modernBlink 1.5s ease-in-out infinite;
        }

        @keyframes modernBlink {
            0%, 100% {
                background: linear-gradient(135deg, #FBBF24 0%, #f59e0b 100%);
                color: #0a0a0a;
                border-color: #FBBF24;
                box-shadow: 0 0 20px rgba(251, 191, 36, 0.6);
            }
            50% {
                background: linear-gradient(135deg, #2a2a2a 0%, #1e1e1e 100%);
                color: #ffffff;
                border-color: rgba(251, 191, 36, 0.3);
                box-shadow: none;
            }
        }

        .ps-bg-green-cube {
            background: linear-gradient(135deg, #FBBF24 0%, #f59e0b 100%);
            color: #0a0a0a;
            border-color: #FBBF24;
            box-shadow: 
                0 4px 12px rgba(251, 191, 36, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
        }

        .ps-bg-wrong-cube {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%) !important;
            color: white !important;
            border-color: #ef4444 !important;
            animation: modernShake 0.5s ease;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3) !important;
        }

        @keyframes modernShake {
            0%, 100% { transform: translateX(0); }
            20% { transform: translateX(-4px) rotate(-1deg); }
            40% { transform: translateX(4px) rotate(1deg); }
            60% { transform: translateX(-4px) rotate(-1deg); }
            80% { transform: translateX(4px) rotate(1deg); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .game-wrapper {
                padding: 1.5rem;
                width: 95vw;
            }
            
            .maze-game-container {
                gap: 0.3rem;
                max-width: 350px;
            }
            
            .each-cube {
                min-height: 40px;
                font-size: 1rem;
            }
            
            .start-dest-cube {
                font-size: 1.2rem;
            }
        }

        @media (max-width: 480px) {
            .game-wrapper {
                padding: 1rem;
            }
            
            .maze-game-container {
                max-width: 280px;
            }
            
            .each-cube {
                min-height: 35px;
                font-size: 0.9rem;
            }
            
            .time-left {
                font-size: 0.9rem;
            }
        }
    </style>
