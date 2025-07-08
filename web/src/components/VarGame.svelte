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
    let blocksInput = $varSettings.amountOfAnswers; 
    let numberOfWrongClicksAllowed = $varSettings.maxAnswersIncorrect;
    let displayNumbersOnCubesFor = $varSettings.timeForNumberDisplay * 100;
    let gameTime = $varSettings.gameTime * 100 + displayNumbersOnCubesFor;
    let counter, gameStarted = false, gameEnded = false;
    let allCubes = [];
    let order = 0, wrongClicks = 0;
    let cubeBgColors = ['#5b3a63', '#0cf4c7', '#ffa700', '#00ff7f', '#ff6f61', '#8a2be2', '#ff1493', ];
    let topLowerBound = 0.2, topHigherBound = 24.8;
    let leftLowerBound = 0.2, leftHigherBound = 26.8;

    onMount(() => {

        let cubeIndicesList = [];
        while(cubeIndicesList.length < blocksInput){
            const r = Math.floor(Math.random() * blocksInput);
            if(cubeIndicesList.indexOf(r) === -1) cubeIndicesList.push(r);
        }
        for(let i = 0; i < cubeIndicesList.length; i++) {
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
        window.addEventListener('keydown', (e: KeyboardEvent) => {
            if (['Escape'].includes(e.code)) {
                fetchNui('var-result', false);
                fetchNui('hideUI');
                varActive.set(false);
                varSettings.set({});
            }
        });
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
            if(order === clickedCube.cubeIndex) {
                let clickedCubeDom = document.getElementById('each-cube-'+clickedCube.cubeIndex);
                clickedCubeDom.style.backgroundColor = '#374151';
                order = order + 1;
            } else {
                wrongClicks = wrongClicks + 1;
                let clickedCubeDom = document.getElementById('each-cube-'+clickedCube.cubeIndex);
                clickedCubeDom.style.backgroundColor = '#dc2626'; // red
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
               fetchNui('var-result', isSuccess);
               fetchNui('hideUI');
               varActive.set(false);
               varSettings.set({})
            }, 1000);
        }
    }
    
</script>

{#if $varActive}
    <div class="overlay">
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
    </div>
{/if}<style>
  .overlay {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 32%;
    height: 65%;
    background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
    z-index: 9998;
}

.var-game-base {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    flex-direction: column;
    height: 32vw;
    justify-content: center;
    align-items: center;
    color: #ffffff;
    z-index: 9999;
}

.var-game-base > .time-left {
    display: flex;
    flex-direction: row;
    justify-content: center;
    font-size: 0.85vw;
}

.var-game-base > .time-left > .clock-icon {
    padding-top: 0.17vw;
    margin-right: 0.3vw;
    color: #FBBF24;
}

.var-game-base > .time-left > .game-timer-var {
    width: 2.5vw;
    color: #FBBF24;
}

.var-game-base > .var-game-container {
    border: 2px solid #171717;
    background: linear-gradient(135deg, #2a2a2a 0%, #1e1e1e 100%);
    margin-top: 1vw;
    width: 30vw;
    height: 28vw;
    position: relative;
}

.var-game-base > .var-game-container > .each-cube {
    width: 3vw;
    height: 3vw;
    border: 2px solid rgba(251, 191, 36, 0.3);
    position: absolute;
    text-align: center;
    cursor: default;
}

.var-game-base > .var-game-container > .each-cube > p {
    font-size: 1.5vw;
    font-weight: bold;
    margin-top: 0.2vw;
    color: #ffffff;
}
</style>