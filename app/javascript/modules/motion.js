function animarContagem(el) {
  const alvo = parseFloat(el.dataset.countUp)
  if (Number.isNaN(alvo)) return

  const formatar = (valor) => `${Math.round(valor)}°`
  const reduz = window.matchMedia("(prefers-reduced-motion: reduce)").matches

  if (reduz) {
    el.textContent = formatar(alvo)
    return
  }

  const inicio = performance.now()
  const duracao = 900

  function passo(agora) {
    const progresso = Math.min((agora - inicio) / duracao, 1)
    const easing = 1 - Math.pow(1 - progresso, 4)
    el.textContent = formatar(alvo * easing)
    if (progresso < 1) requestAnimationFrame(passo)
  }

  requestAnimationFrame(passo)
}

function initScrollNav() {
  const nav = document.querySelector("[data-scroll-nav]")
  if (!nav || nav.dataset.ligado) return
  nav.dataset.ligado = "1"

  const aoRolar = () => nav.classList.toggle("nav-solid", window.scrollY > 8)
  aoRolar()
  window.addEventListener("scroll", aoRolar, { passive: true })
}

function initContagens() {
  document.querySelectorAll("[data-count-up]").forEach(animarContagem)
}

document.addEventListener("turbo:load", () => {
  initScrollNav()
  initContagens()
})

document.addEventListener("clima:atualizado", (event) => {
  event.detail?.raiz?.querySelectorAll("[data-count-up]").forEach(animarContagem)
})
