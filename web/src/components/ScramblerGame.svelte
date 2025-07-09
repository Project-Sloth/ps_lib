<script lang="ts">
    import { onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import {scramblerActive, scramblerSettings} from "../store/ScramblerGame";
    function getRandomArbitrary(min, max) {
	    return Math.floor(Math.random() * (max - min) + min);
    }
    const randomSetChar = () => {
        let str='?';
        switch($scramblerSettings.sets) {
            case 'numeric':
                str="0123456789";
                break;
            case 'alphabet':
                str="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                break;
            case 'alphanumeric':
                str="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                break;
            case 'greek':
                str="ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ";
                break;
            case 'braille':
                str="⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯⡰⡱⡲⡳⡴⡵⡶⡷⡸⡹⡺⡻⡼⡽⡾⡿"+
                    "⢀⢁⢂⢃⢄⢅⢆⢇⢈⢉⢊⢋⢌⢍⢎⢏⢐⢑⢒⢓⢔⢕⢖⢗⢘⢙⢚⢛⢜⢝⢞⢟⢠⢡⢢⢣⢤⢥⢦⢧⢨⢩⢪⢫⢬⢭⢮⢯⢰⢱⢲⢳⢴⢵⢶⢷⢸⢹⢺⢻⢼⢽⢾⢿"+
                    "⣀⣁⣂⣃⣄⣅⣆⣇⣈⣉⣊⣋⣌⣍⣎⣏⣐⣑⣒⣓⣔⣕⣖⣗⣘⣙⣚⣛⣜⣝⣞⣟⣠⣡⣢⣣⣤⣥⣦⣧⣨⣩⣪⣫⣬⣭⣮⣯⣰⣱⣲⣳⣴⣵⣶⣷⣸⣹⣺⣻⣼⣽⣾⣿";
                break;
            case 'runes':
                str="ᚠᚥᚧᚨᚩᚬᚭᚻᛐᛑᛒᛓᛔᛕᛖᛗᛘᛙᛚᛛᛜᛝᛞᛟᛤ";
                break;
        }
        return str.charAt(getRandomArbitrary(0, str.length));
    }

    let gameTimeRemaining = 0;

    let amountOfAnswers = $scramblerSettings.amountOfAnswers; // how many numbers for game
    let gameTime = $scramblerSettings.gameTime * 100; // seconds

    let correctIndices = [], correctAnswers = [];
    let changeBoardAfter = $scramblerSettings.changeBoardAfter * 100; //3 seconds
    let originalChangeBoardAfter = changeBoardAfter;
    let counter, gameStarted = false, gameEnded = false;
    let hackSuccess = false;
    let numberOfCubes = 80, allCubes = [];
    let totalNumberOfColumns = 10;

    let cursorIndices = [], cursorStartIndex = 43;

    onMount(() => {
        //generating an array to maintain each cube data by index
        for(let i = 0; i < numberOfCubes; i++) {
            const cubeData = {
                cubeIndex: i,
                cubeValue: randomSetChar() + randomSetChar(),
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        //generate correct answer values - column number - has to be Number of cols - 4 to have straight 4 answers
        const columnNumber = Math.floor(Math.random() * 5);
        //generate correct answer values - row number
        const rowNumber = Math.floor(Math.random() * 7);

        const startIndex = rowNumber * totalNumberOfColumns + columnNumber;
        correctAnswers = [];
        for(let i = 0; i < amountOfAnswers; i++) {
            correctAnswers.push(allCubes[i + startIndex]);
            correctIndices.push(i+startIndex);
        }

        getCursorIndices();

        //start game
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, 1000);

    });

    function getCursorIndices() {
        cursorIndices = [cursorStartIndex];
        for(let i=1; i<4; i++){
            if( cursorStartIndex+i >= 80 ){
                cursorIndices.push( (cursorStartIndex+i) - 80 );
            }else{
                cursorIndices.push( cursorStartIndex+i );
            }
        }
        // return group;
    }

    function endTheGame() {
        clearInterval(counter);
        gameEnded = true;
        setTimeout(() => {
            fetchNui('scrambler-result', hackSuccess);
            fetchNui('hideUI');
            scramblerActive.set(false);
            scramblerSettings.set({});
        }, 500);
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            hackSuccess = false;
            endTheGame();
            return;
        } else if (changeBoardAfter <= 0) {
            scrambleBoard();
        }

         gameTime--;
         changeBoardAfter--;
         
         gameTimeRemaining = gameTime/100;
    }

    function scrambleBoard() {
        changeBoardAfter = originalChangeBoardAfter;

         //generating an array to maintain each cube data by index
         let newCubeData = [];
         for(let i = 0; i < numberOfCubes; i++) {
            let cubeValue;

            if(i === numberOfCubes - 1) {
                cubeValue = allCubes[0].cubeValue;
            } else {
                cubeValue = allCubes[i+1].cubeValue;
            }
            const cubeData = {
                cubeIndex: i,
                cubeValue: cubeValue,
            };
            newCubeData.push(cubeData);
            newCubeData = newCubeData;
        }
        getCursorIndices();

        allCubes = newCubeData;
    }

    function checkAnswer() {
        let selectedValues = cursorIndices.map((currentCursorIndex) => {
            return allCubes[currentCursorIndex];
        });
        
        const selectedValuesData = selectedValues.map((item) => {
            return item.cubeValue;
        });

        const correctAnswerValues = correctAnswers.map((item) => {
            return item.cubeValue;
        });

        if(JSON.stringify(selectedValuesData) === JSON.stringify(correctAnswerValues)) {
            hackSuccess = true;
        } else {
            hackSuccess = false;
        }

        endTheGame();
    }

    function handleKeyEvent(event) {
        let key_pressed = event.key;
        let valid_keys = ['a','w','s','d', 'A','W','S','D' ,'ArrowUp','ArrowDown','ArrowRight','ArrowLeft','Enter', 'Escape'];

        if(gameStarted && valid_keys.includes(key_pressed) && !gameEnded) {
            switch(key_pressed){
                case 'w':
                case 'ArrowUp':
                    cursorStartIndex -= 10;
                    if(cursorStartIndex < 0) {
                        cursorStartIndex += 80;
                    }
                    break;
                case 's':
                case 'ArrowDown':
                    cursorStartIndex += 10;
                    cursorStartIndex %= 80;
                    break;
                case 'a':
                case 'ArrowLeft':
                    cursorStartIndex--;
                    if(cursorStartIndex < 0) {
                        cursorStartIndex = 79;
                    }
                    break;
                case 'd':
                case 'ArrowRight':
                    cursorStartIndex++;
                    cursorStartIndex %= 80;
                    break;
                case 'Enter':
                    clearInterval(counter);
                    checkAnswer();
                    return;
                case 'Escape':
                    fetchNui('scrambler-result', false);
                    fetchNui('hideUI');
                    scramblerActive.set(false);
                    scramblerSettings.set({});
                    return;
            }
        }
    }

    $: {
        if(cursorStartIndex) {
            getCursorIndices();
        }
    }
</script>

<svelte:window on:keydown|preventDefault={handleKeyEvent} />
<div class="scrambler-game-base">
    <div class="game-info-container">
        <div class="scrambler-find-data">
            <p>Match the numbers underneath.</p>
            <div class="original-data-wrapper">
                {#each correctAnswers as value}
                    <p class="original-digits">{value.cubeValue}</p>
                {/each}
            </div>
        </div>
        <div class="time-left">
            <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
            <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
        </div>
    </div>
    
    <div id="scrambler-game-container" class="scrambler-game-container">
        {#each allCubes as cube}
            <div id={'each-cube-'+cube.cubeIndex} class="each-cube">
                <p class="{!gameEnded && cursorIndices.includes(cube.cubeIndex) ? 'ps-text-red' : ''}">{cube.cubeValue}</p>
            </div>
        {/each}
    </div>
</div>

<style>
    .scrambler-game-base {
    display: flex;
    flex-direction: column;
    height: 28vw;
    width: 32vw;
    justify-content: center;
    align-items: center;
    color: #e5e7eb;
    background: linear-gradient(135deg, #0f0f0f 0%, #1a1a1a 50%, #111111 100%);
    border: 1px solid #262626;
    border-radius: 24px;
    padding: 2.5rem;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    position: absolute;
    overflow: hidden;
}

.scrambler-game-base::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at 50% 50%, rgba(251, 191, 36, 0.03) 0%, transparent 70%);
    pointer-events: none;
}

.game-info-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: 1rem;
    position: relative;
    z-index: 1;
}

.scrambler-find-data {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.75rem;
}

.scrambler-find-data > p {
    color: #f8fafc;
    font-weight: 500;
    font-size: 1.1rem;
    text-align: center;
    margin: 0;
    letter-spacing: 0.025em;
}

.original-data-wrapper {
    display: flex;
    flex-direction: row;
    gap: 0.5rem;
    padding: 0.75rem 1.25rem;
    background: linear-gradient(135deg, #1a1a1a 0%, #262626 100%);
    border: 2px solid #333333;
    border-radius: 16px;
    position: relative;
    overflow: hidden;
}

.original-data-wrapper::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.08) 0%, transparent 50%);
    border-radius: 14px;
}

.original-data-wrapper::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, #FBBF24 50%, transparent 100%);
    opacity: 0.6;
}

.original-digits {
    font-size: 1.2rem;
    font-weight: 700;
    color: #f1f5f9;
    margin: 0;
    padding: 0.25rem 0.5rem;
    background: rgba(251, 191, 36, 0.1);
    border-radius: 8px;
    position: relative;
    z-index: 1;
    text-shadow: 0 0 8px rgba(251, 191, 36, 0.2);
    letter-spacing: 0.05em;
}

.time-left {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.9rem;
    background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
    border: 1px solid #333333;
    border-radius: 12px;
    padding: 0.75rem 1.5rem;
    position: relative;
    overflow: hidden;
}

.time-left::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.05) 0%, transparent 50%);
}

.clock-icon {
    color: #FBBF24;
    font-size: 1rem;
    position: relative;
    z-index: 1;
    filter: drop-shadow(0 0 4px rgba(251, 191, 36, 0.3));
}

.game-timer-var {
    color: #FBBF24;
    font-weight: 700;
    width: 2.5rem;
    text-align: center;
    position: relative;
    z-index: 1;
    text-shadow: 0 0 8px rgba(251, 191, 36, 0.3);
}

.scrambler-game-container {
    margin-top: 1.5rem;
    width: 30vw;
    height: 24vw;
    display: grid;
    grid-template-columns: repeat(10, 1fr);
    grid-template-rows: repeat(8, 1fr);
    gap: 0.4vw;
    background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
    border: 1px solid #262626;
    border-radius: 20px;
    padding: 1.5rem;
    position: relative;
    overflow: hidden;
}

.scrambler-game-container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        radial-gradient(circle at 20% 20%, rgba(251, 191, 36, 0.02) 0%, transparent 50%),
        radial-gradient(circle at 80% 80%, rgba(251, 191, 36, 0.02) 0%, transparent 50%);
    pointer-events: none;
}

.each-cube {
    width: 100%;
    height: 100%;
    font-size: 1.4vw;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #262626 0%, #1a1a1a 100%);
    border: 1px solid #333333;
    border-radius: 8px;
    position: relative;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
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

.each-cube::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, rgba(251, 191, 36, 0.3) 50%, transparent 100%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.each-cube:hover::before,
.each-cube:hover::after {
    opacity: 1;
}

.each-cube:hover {
    border-color: rgba(251, 191, 36, 0.4);
    box-shadow: 
        0 0 16px rgba(251, 191, 36, 0.15),
        inset 0 1px 0 rgba(251, 191, 36, 0.1);
    transform: translateY(-1px) scale(1.02);
    background: linear-gradient(135deg, #2a2a2a 0%, #1e1e1e 100%);
}

.each-cube > p {
    color: #e2e8f0;
    font-weight: 600;
    margin: 0;
    position: relative;
    z-index: 1;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
    letter-spacing: 0.025em;
    transition: all 0.3s ease;
}

.each-cube:hover > p {
    color: #f8fafc;
    text-shadow: 0 0 8px rgba(251, 191, 36, 0.2);
}

/* Active cursor selection styles */
.ps-text-red {
    color: #FBBF24 !important;
    text-shadow: 
        0 0 12px rgba(251, 191, 36, 0.6),
        0 0 24px rgba(251, 191, 36, 0.3) !important;
    font-weight: 700 !important;
}

.ps-text-red::selection {
    background: rgba(251, 191, 36, 0.2);
}

/* Active cube highlighting for cursor selection */
.each-cube:has(.ps-text-red) {
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.15) 0%, rgba(251, 191, 36, 0.08) 100%);
    border-color: #FBBF24;
    box-shadow: 
        0 0 20px rgba(251, 191, 36, 0.3),
        inset 0 1px 0 rgba(251, 191, 36, 0.2);
    transform: scale(1.05);
}

.each-cube:has(.ps-text-red)::before {
    opacity: 1;
    background: linear-gradient(135deg, rgba(251, 191, 36, 0.2) 0%, transparent 50%);
}

.each-cube:has(.ps-text-red)::after {
    opacity: 1;
    background: linear-gradient(90deg, transparent 0%, #FBBF24 50%, transparent 100%);
}

/* Responsive adjustments */
@media (max-width: 1200px) {
    .scrambler-game-base {
        height: 32vw;
        padding: 2rem;
    }
    
    .scrambler-game-container {
        width: 35vw;
        height: 28vw;
    }
    
    .each-cube {
        font-size: 1.6vw;
    }
}

@media (max-width: 768px) {
    .scrambler-game-base {
        height: 40vw;
        padding: 1.5rem;
    }
    
    .scrambler-game-container {
        width: 45vw;
        height: 35vw;
    }
    
    .each-cube {
        font-size: 2vw;
    }
}
</style>