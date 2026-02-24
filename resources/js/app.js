import './bootstrap';
function pad(n) {
  return String(n).padStart(2, "0");
}

function getGreeting(h) {
  if (h >= 5 && h < 12) return "Good Morning!";
  if (h >= 12 && h < 15) return "Good Afternoon!";
  if (h >= 15 && h < 19) return "Good Evening!";
  return "Good Night!";
}

function tick() {
  const el = document.getElementById("clock");
  const gr = document.getElementById("greeting");
  const now = new Date();

  if (el) {
    const hh = pad(now.getHours());
    const mm = pad(now.getMinutes());
    const ss = pad(now.getSeconds());
    el.textContent = `${hh}:${mm}:${ss}`;
  }

  if (gr) gr.textContent = getGreeting(now.getHours());
}

document.addEventListener("DOMContentLoaded", () => {
  tick();
  setInterval(tick, 1000);
});