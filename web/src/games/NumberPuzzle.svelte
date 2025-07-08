<script lang="ts">

    import {varActive, varSettings} from "../store/VarGame";
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import mojs from '@mojs/core';

    function convertVwToPx(vw) {
	    return (document.documentElement.clientWidth * vw) / 100;
    }
    function getRandomArbitrary(min, max) {
	    return Math.floor(Math.random() * (max - min) + min);
    }
    let gameTimeRemaining = 0;

    let blocksInput = $varSettings.amountOfAnswers; // how many cubes to remember for game - increment number based on difficulty level
    
    let numberOfWrongClicksAllowed = $varSettings.maxAnswersIncorrect;
    let displayNumbersOnCubesFor = $varSettings.timeForNumberDisplay * 100;
    let gameTime = $varSettings.gameTime * 100 + displayNumbersOnCubesFor;
    let counter, gameStarted = false, gameEnded = false;
    let allCubes = [];
    let order = 0, wrongClicks = 0;
    let cubeBgColors = ['#FFA726', '#FFEB3B', '#FFC107'];

    // let topLowerBound = 290, topHigherBound = 660; px
    // let leftLowerBound = 77, leftHigherBound = 459;
    let topLowerBound = 1, topHigherBound = 24; //vw (adjusted to keep cubes inside container)
    let leftLowerBound = 1, leftHigherBound = 26; //vw (adjusted to keep cubes inside container)

    onMount(() => {
        //generate shuffled cubes indices
        let cubeIndicesList = [];
        while(cubeIndicesList.length < blocksInput){
            const r = Math.floor(Math.random() * blocksInput);
            if(cubeIndicesList.indexOf(r) === -1) cubeIndicesList.push(r);
        }

        //generating an array to maintain each cube data by index
        for(let i = 0; i < cubeIndicesList.length; i++) {
            //height between 290 and 660 px
            //horizontal between 77 and 459 px
            const cubeData = {
                cubeIndex: cubeIndicesList[i],
                cubeValue: cubeIndicesList[i],
                bgColor: cubeBgColors[Math.floor(Math.random() * cubeBgColors.length)],
                top: getRandomArbitrary(topLowerBound, topHigherBound),
                left: getRandomArbitrary(leftLowerBound, leftHigherBound)
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        //stop showing the correct cubes and start the guessing game
        setTimeout(() => {
            gameStarted = true;

            let eachCube = document.querySelectorAll('.each-cube');
            eachCube.forEach(el => { newPos(el) });

            counter = setInterval(startTimer, 10);
        }, 1000);
    });

    function newPos(element) {
        let top = element.offsetTop;
        let left = element.offsetLeft;

        let new_top_vw = getRandomArbitrary(topLowerBound,topHigherBound);
        let new_left_vw = getRandomArbitrary(leftLowerBound,leftHigherBound);

        // Bump the top position 30% higher
        new_top_vw = new_top_vw * 0.7; // Move 30% higher (multiply by 0.7)

        let new_top = convertVwToPx(new_top_vw);
        let new_left = convertVwToPx(new_left_vw);

        let diff_top = new_top - top;
        let diff_left = new_left - left;
        
        let duration = getRandomArbitrary(10,40)*100;
        
        new mojs.Html({
            el: '#'+element.id,
            x: {
                0:diff_left,
                duration: duration,
                easing: 'linear.none'
            },
            y: {
                0:diff_top,
                duration: duration,
                easing: 'linear.none'
            },
            duration: duration+50,
            onComplete() {
                if(element.offsetTop === 0 && element.offsetLeft === 0) {
                    this.pause();
                    return;
                }
                const bgColor = element.style.backgroundColor;
                element.style = 'background-color: '+bgColor+'; top: '+new_top_vw+'vw; left: '+new_left_vw+'vw; transform: none;';
                newPos(element);
            },
            onUpdate() {
                if(gameStarted === false) this.pause();
            }
        }).play();
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            endGame(false);
            return;
        } 
        displayNumbersOnCubesFor--;
        gameTime--;        
        gameTimeRemaining = gameTime/100;
    }

    function handleClick(clickedCube) {
        if(gameStarted && !gameEnded && displayNumbersOnCubesFor <= 0) {
            //correct click
            if(order === clickedCube.cubeIndex) {
                let clickedCubeDom = document.getElementById('each-cube-'+clickedCube.cubeIndex);
                clickedCubeDom.style.backgroundColor = '#2d2d2d;';
                order = order + 1;
            } else {
                wrongClicks = wrongClicks + 1;
            }
            checkGameStatus();
        }
       
    }

    function checkGameStatus() {
        if(order === allCubes.length - 1 && wrongClicks < numberOfWrongClicksAllowed) {
            endGame(true);
        } else if(order < allCubes.length - 1 && wrongClicks >= numberOfWrongClicksAllowed) {
            endGame(false);
        }
    }

    function endGame(isSuccess) {
        if(!gameEnded) {
            gameEnded = true;
            clearInterval(counter);
            
            setTimeout(() => {
                if(!isDevMode) {
                    fetchNui('var-result', isSuccess);
                    fetchNui('psui:close');
                    dispatch('game-ended', { hackSuccess: isSuccess });
                }
                dispatch('minigame:callback', {hackSuccess: isSuccess});
            }, 1000);
        }
    }

    function handleKeyEvent(event) {
        let key_pressed = event.key;
        let valid_keys = ['Escape'];

        if(gameStarted && valid_keys.includes(key_pressed) && !gameEnded) {
            switch(key_pressed){
                case 'Escape':
                    endGame(false);
                    return;
            }
        }
    }
</script>

<svelte:window on:keydown|preventDefault={handleKeyEvent} />
<div class="var-game-base">
    <div class="time-left">
        <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
        <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
    </div>
    
    <div id="var-game-container" class="var-game-container">
        {#each allCubes as cube}
            <div 
                id={'each-cube-'+cube.cubeIndex} 
                class="each-cube"
                style="background-color:{cube.bgColor}; top: {cube.top}vw; left: {cube.left}vw;"
                on:click={() => handleClick(cube)}
            >
                {#if displayNumbersOnCubesFor > 0}
                    <p>{cube.cubeValue + 1}</p>
                {/if}
            </div>
        {/each}
    </div>
</div>
<style>
    .var-game-base {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        
        display: flex;
        flex-direction: column;

        height: 28vw;
        justify-content: center;
        align-items: center;
        color: #E0E0E0;
        z-index: 9999;
        background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
        border-radius: 1vw;
        padding: 2vw;
        box-shadow: 0 1vw 3vw rgba(0, 0, 0, 0.5);
    }

    .var-game-base > .time-left {
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
        font-size: 0.85vw;
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10px);
        border-radius: 0.5vw;
        padding: 0.5vw 1vw;
        margin-bottom: 1vw;
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .var-game-base > .time-left > .clock-icon {
        padding-top: 0.17vw;
        margin-right: 0.3vw;
        color: #D4A574;
        font-size: 1vw;
    }

    .var-game-base > .time-left > .game-timer-var {
        width: 2.5vw;
        color: #D4A574;
        font-weight: bold;
    }

    .var-game-base > .var-game-container {
        border: 2px solid #B8860B;
        background: linear-gradient(145deg, #8B4513 0%, #A0522D 50%, #CD853F 100%);
        margin-top: 1vw;
        width: 30vw;
        height: 28vw;
        border-radius: 0.5vw;
        position: relative;
        overflow: hidden;
        box-shadow: 
            inset 0 0 2vw rgba(0, 0, 0, 0.3),
            0 0.5vw 1vw rgba(0, 0, 0, 0.2);
    }

    .var-game-base > .var-game-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
            radial-gradient(circle at 20% 20%, rgba(212, 165, 116, 0.1) 0%, transparent 50%),
            radial-gradient(circle at 80% 80%, rgba(205, 133, 63, 0.1) 0%, transparent 50%);
        pointer-events: none;
    }

    .var-game-base > .var-game-container > .each-cube {
        width: 3vw;
        height: 3vw;
        border: 2px solid #444;
        position: absolute;
        text-align: center;
        cursor: pointer;
        border-radius: 0.3vw;
        transition: all 0.2s ease;
        box-shadow: 
            0 0.2vw 0.5vw rgba(0, 0, 0, 0.3),
            inset 0 0.1vw 0.2vw rgba(255, 255, 255, 0.2);
    }

    .var-game-base > .var-game-container > .each-cube:hover {
        transform: scale(1.05);
        box-shadow: 
            0 0.3vw 1vw rgba(0, 0, 0, 0.4),
            inset 0 0.1vw 0.2vw rgba(255, 255, 255, 0.3),
            0 0 1vw rgba(212, 165, 116, 0.5);
    }

    .var-game-base > .var-game-container > .each-cube > p {
        font-size: 1.5vw;
        font-weight: bold;
        margin-top: 0.2vw;
        color: #1a1a1a
        text-shadow: 0 0.1vw 0.2vw rgba(255, 255, 255, 0.3);
    }

    @keyframes pulse {
        0%, 100% { 
            box-shadow: 
                0 0.2vw 0.5vw rgba(0, 0, 0, 0.3),
                inset 0 0.1vw 0.2vw rgba(255, 255, 255, 0.2);
        }
        50% { 
            box-shadow: 
                0 0.3vw 1vw rgba(0, 0, 0, 0.4),
                inset 0 0.1vw 0.2vw rgba(255, 255, 255, 0.3),
                0 0 1.5vw rgba(212, 165, 116, 0.6);
        }
    }

    .var-game-base > .var-game-container > .each-cube:active {
        animation: pulse 0.3s ease-in-out;
    }
</style>