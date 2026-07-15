<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Snake Game</title>
    <style>
        :root {
            --bg1: #fff5f9;
            --bg2: #f9a8d4;
            --panel: rgba(255, 255, 255, 0.82);
            --accent: #ec4899;
            --accent-2: #f472b6;
            --text: #4a2440;
            --muted: #7c4d6b;
            --button: linear-gradient(135deg, #f472b6, #ec4899);
            --button-hover: linear-gradient(135deg, #ec4899, #db2777);
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #fff7fb 0%, #ffe4f1 45%, #fbcfe8 100%);
            color: var(--text);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .card {
            background: var(--panel);
            border: 1px solid rgba(236, 72, 153, 0.18);
            border-radius: 24px;
            padding: 28px;
            box-shadow: 0 18px 40px rgba(236, 72, 153, 0.16);
            text-align: center;
            backdrop-filter: blur(10px);
        }

        h1 {
            margin-top: 0;
            margin-bottom: 8px;
            font-size: 2rem;
            color: var(--accent);
            font-weight: 800;
        }

        p {
            color: var(--muted);
            margin-bottom: 16px;
        }

        canvas {
            border: 3px solid #f9a8d4;
            background: linear-gradient(180deg, #fffafc, #ffe4f1);
            border-radius: 12px;
            box-shadow: inset 0 0 20px rgba(236, 72, 153, 0.12);
        }

        #score {
            font-weight: 700;
            margin-top: 12px;
            color: #b45309;
        }

        button {
            margin-top: 14px;
            padding: 10px 16px;
            border: none;
            border-radius: 999px;
            background: var(--button);
            color: white;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 8px 18px rgba(236, 72, 153, 0.25);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        button:hover {
            background: var(--button-hover);
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(236, 72, 153, 0.3);
        }

        .heart {
            position: absolute;
            font-size: 1.2rem;
            pointer-events: none;
            animation: floatHeart 2s ease-out forwards;
            z-index: 10;
        }

        @keyframes floatHeart {
            0% {
                opacity: 0;
                transform: translate3d(0, 0, 0) scale(0.4);
            }
            20% {
                opacity: 1;
            }
            100% {
                opacity: 0;
                transform: translate3d(var(--drift), 140px, 0) scale(1.2);
            }
        }
    </style>
</head>
<body>
<div class="card">
    <h1>Snake Game</h1>
    <p>Use arrow keys or WASD to move. Eat the food and avoid crashing.</p>
    <canvas id="game" width="400" height="400"></canvas>
    <div id="score">Score: 0</div>
    <button onclick="restartGame()">Restart</button>
</div>

<script>
    const canvas = document.getElementById('game');
    const ctx = canvas.getContext('2d');
    const tileSize = 20;
    const boardSize = 20;
    let snake = [{x: 10, y: 10}, {x: 9, y: 10}, {x: 8, y: 10}];
    let direction = {x: 1, y: 0};
    let nextDirection = {x: 1, y: 0};
    let food = {x: 15, y: 10};
    let score = 0;
    let gameLoop;

    function drawBoard() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        for (let i = 0; i < boardSize; i++) {
            for (let j = 0; j < boardSize; j++) {
                ctx.strokeStyle = '#1e293b';
                ctx.strokeRect(i * tileSize, j * tileSize, tileSize, tileSize);
            }
        }
    }

    function drawSnake() {
        snake.forEach((segment, index) => {
            ctx.fillStyle = index === 0 ? '#ef4444' : '#dc2626';
            ctx.fillRect(segment.x * tileSize, segment.y * tileSize, tileSize, tileSize);

            if (index === 0) {
                const headX = segment.x * tileSize;
                const headY = segment.y * tileSize;
                const eyeSize = 3;
                const eyeOffset = 5;

                if (direction.x === 1) {
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(headX + 10, headY + 6, eyeSize, eyeSize);
                    ctx.fillRect(headX + 10, headY + 11, eyeSize, eyeSize);
                } else if (direction.x === -1) {
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(headX + 2, headY + 6, eyeSize, eyeSize);
                    ctx.fillRect(headX + 2, headY + 11, eyeSize, eyeSize);
                } else if (direction.y === -1) {
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(headX + 6, headY + 2, eyeSize, eyeSize);
                    ctx.fillRect(headX + 11, headY + 2, eyeSize, eyeSize);
                } else {
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(headX + 6, headY + 10, eyeSize, eyeSize);
                    ctx.fillRect(headX + 11, headY + 10, eyeSize, eyeSize);
                }
            }
        });
    }

    function drawFood() {
        ctx.fillStyle = '#22c55e';
        ctx.fillRect(food.x * tileSize, food.y * tileSize, tileSize, tileSize);
    }

    function placeFood() {
        food = {
            x: Math.floor(Math.random() * boardSize),
            y: Math.floor(Math.random() * boardSize)
        };
        if (snake.some(segment => segment.x === food.x && segment.y === food.y)) {
            placeFood();
        }
    }

    function updateScore() {
        document.getElementById('score').textContent = 'Score: ' + score;
    }

    function gameOver() {
        clearInterval(gameLoop);
        document.getElementById('score').textContent = 'Game over! Final score: ' + score;
        burstHearts();
    }

    function burstHearts() {
        const container = document.querySelector('.card');
        for (let i = 0; i < 24; i++) {
            const heart = document.createElement('div');
            heart.className = 'heart';
            heart.innerHTML = '💖';
            heart.style.left = Math.random() * 100 + '%';
            heart.style.top = Math.random() * 40 + 20 + '%';
            heart.style.setProperty('--drift', (Math.random() * 120 - 60) + 'px');
            heart.style.animationDelay = (Math.random() * 0.2) + 's';
            container.appendChild(heart);
            setTimeout(() => heart.remove(), 2200);
        }
    }

    function step() {
        direction = nextDirection;
        const head = {x: snake[0].x + direction.x, y: snake[0].y + direction.y};

        if (head.x < 0 || head.x >= boardSize || head.y < 0 || head.y >= boardSize ||
            snake.some(segment => segment.x === head.x && segment.y === head.y)) {
            gameOver();
            return;
        }

        snake.unshift(head);

        if (head.x === food.x && head.y === food.y) {
            score += 10;
            updateScore();
            placeFood();
        } else {
            snake.pop();
        }

        drawBoard();
        drawFood();
        drawSnake();
    }

    function restartGame() {
        clearInterval(gameLoop);
        snake = [{x: 10, y: 10}, {x: 9, y: 10}, {x: 8, y: 10}];
        direction = {x: 1, y: 0};
        nextDirection = {x: 1, y: 0};
        score = 0;
        updateScore();
        placeFood();
        drawBoard();
        drawFood();
        drawSnake();
        gameLoop = setInterval(step, 120);
    }

    document.addEventListener('keydown', (event) => {
        const key = event.key.toLowerCase();
        event.preventDefault();

        if (key === 'arrowup' || key === 'w') {
            if (direction.y === 1) return;
            nextDirection = {x: 0, y: -1};
        } else if (key === 'arrowdown' || key === 's') {
            if (direction.y === -1) return;
            nextDirection = {x: 0, y: 1};
        } else if (key === 'arrowleft' || key === 'a') {
            if (direction.x === 1) return;
            nextDirection = {x: -1, y: 0};
        } else if (key === 'arrowright' || key === 'd') {
            if (direction.x === -1) return;
            nextDirection = {x: 1, y: 0};
        }
    });

    restartGame();
</script>
</body>
</html>
