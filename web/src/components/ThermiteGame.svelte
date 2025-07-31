<script lang="ts">
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import {thermActive, thermSettings} from "../store/ThermiteGame";


    let gridSizesAcceptable = [
        {
            numberOfRowCol: 5,
            cubeSize: '4.2vw',
            gap: '1vw'
        },
        {
            numberOfRowCol: 6,
            cubeSize: '3.7vw',
            gap: '0.8vw'
        },
        {
            numberOfRowCol: 7,
            cubeSize: '2.9vw',
            gap: '1vw'
        },
        {
            numberOfRowCol: 8,
            cubeSize: '2.6vw',
            gap: '0.9vw'
        },
        {
            numberOfRowCol: 9,
            cubeSize: '2.4vw',
            gap: '0.75vw'
        },
        {
            numberOfRowCol: 10,
            cubeSize: '2.1vw',
            gap: '0.75vw'
        },
    ];

    let gameTimeRemaining = 0;

    let numberOfCorrectCubesToDisplay = $thermSettings.amountOfAnswers;
    let gameTime = $thermSettings.gameTime * 100;
    let numberOfWrongClicksAllowed = $thermSettings.maxAnswersIncorrect;

    let correctIndices = [], displayCorrectIndicesFor = $thermSettings.displayInitialAnswersFor * 1000;
    let counter, gameStarted = false, gameEnded = false;
    let hackSuccess = false;
    let numberOfCubes = $thermSettings.gridSize * $thermSettings.gridSize;
    let allCubes = [];

    onMount(() => {
        while(correctIndices.length < numberOfCorrectCubesToDisplay){
            const r = Math.floor(Math.random() * numberOfCubes);
            if(correctIndices.indexOf(r) === -1) correctIndices.push(r);
        }

        for(let i = 0; i < numberOfCubes; i++) {
            const cubeData = {
                cubeIndex: i,
                isCorrectAnswer: correctIndices.includes(i),
                isClicked: false
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        let cubeWidthHeightValue = gridSizesAcceptable.filter((accept) => {
            return accept.numberOfRowCol === $thermSettings.gridSize;
        })[0];

        setTimeout(() => {
            allCubes.forEach((cube) => {
                const gameContainer = document.getElementById('memory-game-container');
                if(gameContainer) {
                    gameContainer.style.gap = cubeWidthHeightValue.gap;
                }
                
                const cubeDom = document.getElementById('each-cube-'+cube.cubeIndex);
                if(cubeDom) {
                    cubeDom.style.width = cubeWidthHeightValue.cubeSize;
                    cubeDom.style.height = cubeWidthHeightValue.cubeSize;
                    cubeDom.style.border = "2px solid var(--color-green)";
                }
            });
        }, 1500);
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, displayCorrectIndicesFor + 1500);

    });

    function startTimer() {
        if (gameTime <= 0)
        {
            gameEnded = true;
            hackSuccess = isSuccessful();
            clearInterval(counter);
            return;
         }
         gameTime--;
         gameTimeRemaining = gameTime/100;
    }

    function isSuccessful() {
        const allCorrectClicked = allCubes
            .filter(cube => cube.isCorrectAnswer)
            .every(cube => cube.isClicked);
        
        const wrongClicks = getWrongClicks();
        
        return allCorrectClicked && wrongClicks.length <= numberOfWrongClicksAllowed;
    }

    function getWrongClicks() {
        return allCubes.filter((item) => {
            return item.isClicked && !item.isCorrectAnswer;
        });
    }

    function guessAnswer(guessedCube) {
        if(!gameEnded) {
            const cubeIndexInArray = allCubes.findIndex((item) => item.cubeIndex === guessedCube.cubeIndex);

            let updatedCube = guessedCube;
            updatedCube.isClicked = true;

            allCubes[cubeIndexInArray] = updatedCube;

            const wrongClickedCubes = getWrongClicks();

            if(wrongClickedCubes.length >= numberOfWrongClicksAllowed) {
                clearInterval(counter);
                setTimeout(() => {
                    hackSuccess = false;
                    gameTimeRemaining = 0;
                    gameEnded = true;
                    return;
                }, 500);
            } 
            
            hackSuccess = isSuccessful();

            if(hackSuccess) {
                clearInterval(counter);
                gameTimeRemaining = 0;
                gameEnded = true;
            }
        }
    }

    $: {
        if(gameEnded) {
            fetchNui('thermite-result', hackSuccess);
            fetchNui('hideUI');
            thermActive.set(false);
            thermSettings.set([]);
        }
    }

    function handleKeyEvent(event) {
        let key_pressed = event.key;
        let valid_keys = ['Escape'];

        if(gameStarted && valid_keys.includes(key_pressed) && !gameEnded) {
            switch(key_pressed){
                case 'Escape':
                    fetchNui('thermite-result', false);
                    fetchNui('hideUI');
                    thermActive.set(false);
                    thermSettings.set([]);
                    return;
            }
        }
    }
</script>
<svelte:window on:keydown|preventDefault={handleKeyEvent} />
<div class="game-container">
    <div class="timer">
        <i class="fa-solid fa-clock icon"></i>
        <span class="time">{gameTimeRemaining}</span> seconds remaining
    </div>

    <div id="memory-game-container" class="grid" style="gap: 13px;">
        {#each allCubes as cube}
            <div 
                id={'each-cube-'+cube.cubeIndex} 
                on:click={(e) => gameStarted ? guessAnswer(cube) : e.preventDefault()}
                style="width: 0px; height: 0px; border: 0px;"
                class="cube 
                    {gameStarted ? 'cursor-pointer' : 'cursor-default'} 
                    {!gameStarted ? (cube.isCorrectAnswer ? 'correct' : '') : (
                        cube.isClicked && cube.isCorrectAnswer ? 'correct' : 
                        (cube.isClicked && !cube.isCorrectAnswer ? 'wrong' : '')
                    )}
                ">
            </div>
        {/each}
    </div>
</div>

<style>
    .game-container {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 34vw;
        height: 30vw;
        background: linear-gradient(135deg, #0f0f0f, #1a1a1a);
        border-radius: 20px;
        box-shadow: 0 0 20px rgba(255, 255, 255, 0.05);
        border: 1px solid #262626;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 2rem;
        overflow: hidden;
    }

    .timer {
        font-size: 1.1vw;
        color: #d1d5db;
        display: flex;
        align-items: center;
        gap: 0.5vw;
        padding: 0.75rem 1.5rem;
        background: #1a1a1a;
        border-radius: 12px;
        border: 1px solid #333;
        margin-bottom: 1vw;
    }

    .icon {
        color: #fbbf24;
    }

    .time {
        color: #fbbf24;
        font-weight: bold;
        width: 2.5vw;
        text-align: center;
    }

    .grid {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 1vw;
        width: 30vw;
        height: 29vw;
        background-color: #1f1f1f;
        border-radius: 12px;
        padding: 1vw;
        box-shadow: inset 0 0 8px rgba(0, 0, 0, 0.5);
    }

    .cube {
        background-color: #1f1f1f;
        border: 2px solid #373737;
        border-radius: 6px;
        transition: all 0.2s ease-in-out;
        cursor: default;
    }

    .cube:hover {
        border-color: #fbbf24;
        transform: scale(1.05);
    }

    .correct {
        background-color: #fbbf24;
        border-color: #fbbf24;
        box-shadow: 0 0 8px rgba(251, 191, 36, 0.4);
    }

    .wrong {
        background-color: #ef4444;
        border-color: #ef4444;
        box-shadow: 0 0 8px rgba(239, 68, 68, 0.4);
    }

    .cursor-pointer {
        cursor: pointer;
    }

    .cursor-default {
        cursor: default;
    }
</style>