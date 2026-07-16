// ===============================
// AWS Celebration Animation
// ===============================

const button = document.getElementById("celebrateBtn");
const popup = document.getElementById("popup");
const closePopup = document.getElementById("closePopup");
const canvas = document.getElementById("fireworks");
const ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

window.addEventListener("resize", () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
});

// ===============================
// FIREWORKS
// ===============================

let particles = [];

class Particle{

    constructor(x,y,color){

        this.x=x;
        this.y=y;

        this.radius=Math.random()*3+2;

        this.color=color;

        this.speedX=(Math.random()-0.5)*10;

        this.speedY=(Math.random()-0.5)*10;

        this.alpha=1;

    }

    update(){

        this.x+=this.speedX;

        this.y+=this.speedY;

        this.speedY+=0.05;

        this.alpha-=0.015;

    }

    draw(){

        ctx.save();

        ctx.globalAlpha=this.alpha;

        ctx.beginPath();

        ctx.arc(this.x,this.y,this.radius,0,Math.PI*2);

        ctx.fillStyle=this.color;

        ctx.fill();

        ctx.restore();

    }

}

function explode(x,y){

    const colors=[
        "#ff69b4",
        "#ff1493",
        "#ffb6c1",
        "#ff85c1",
        "#ffc0cb",
        "#ffffff"
    ];

    for(let i=0;i<120;i++){

        particles.push(
            new Particle(
                x,
                y,
                colors[Math.floor(Math.random()*colors.length)]
            )
        );

    }

}

function animate(){

    ctx.clearRect(0,0,canvas.width,canvas.height);

    particles.forEach((particle,index)=>{

        particle.update();

        particle.draw();

        if(particle.alpha<=0){

            particles.splice(index,1);

        }

    });

    requestAnimationFrame(animate);

}

animate();

// ===============================
// CONFETTI
// ===============================

function confetti(){

    for(let i=0;i<120;i++){

        const piece=document.createElement("div");

        piece.style.position="fixed";

        piece.style.left=Math.random()*100+"vw";

        piece.style.top="-20px";

        piece.style.width="10px";

        piece.style.height="16px";

        piece.style.background=
        ["#ff69b4","#ffd1dc","#ff1493","#fff","#ffc0cb"]
        [Math.floor(Math.random()*5)];

        piece.style.borderRadius="3px";

        piece.style.zIndex="9999";

        piece.style.transition="transform 4s linear, opacity 4s";

        document.body.appendChild(piece);

        setTimeout(()=>{

            piece.style.transform=
            `translateY(${window.innerHeight+50}px)
             rotate(${Math.random()*720}deg)`;

            piece.style.opacity=0;

        },50);

        setTimeout(()=>{

            piece.remove();

        },4500);

    }

}

// ===============================
// HEART EXPLOSION
// ===============================

function hearts(){

    for(let i=0;i<35;i++){

        const heart=document.createElement("div");

        heart.innerHTML="💖";

        heart.style.position="fixed";

        heart.style.left="50%";

        heart.style.top="60%";

        heart.style.fontSize=(20+Math.random()*20)+"px";

        heart.style.pointerEvents="none";

        heart.style.zIndex="9999";

        document.body.appendChild(heart);

        const x=(Math.random()-0.5)*700;

        const y=(Math.random()-0.5)*500;

        heart.animate([

            {
                transform:"translate(0,0) scale(1)",
                opacity:1
            },

            {
                transform:`translate(${x}px,${y}px) scale(.2)`,
                opacity:0
            }

        ],{

            duration:2000

        });

        setTimeout(()=>{

            heart.remove();

        },2000);

    }

}

// ===============================
// BUTTON CLICK
// ===============================

button.addEventListener("click",()=>{

    button.style.transform="scale(.95)";

    setTimeout(()=>{

        button.style.transform="scale(1)";

    },150);

    for(let i=0;i<6;i++){

        setTimeout(()=>{

            explode(
                Math.random()*canvas.width,
                Math.random()*canvas.height/2
            );

        },i*300);

    }

    confetti();

    hearts();

    popup.style.display="flex";

});

// ===============================
// CLOSE POPUP
// ===============================

closePopup.addEventListener("click",()=>{

    popup.style.display="none";

});