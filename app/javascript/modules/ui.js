function initDropdowns() {
  document.querySelectorAll("[data-dropdown]").forEach((wrapper) => {
    if (wrapper.dataset.ligado) return
    wrapper.dataset.ligado = "1"

    const botao = wrapper.querySelector("[data-dropdown-button]")
    const menu = wrapper.querySelector("[data-dropdown-menu]")
    const chevron = wrapper.querySelector("[data-dropdown-chevron]")
    if (!botao || !menu) return

    const fechar = () => {
      menu.hidden = true
      botao.setAttribute("aria-expanded", "false")
      chevron?.classList.remove("rotate-180")
    }

    botao.addEventListener("click", (event) => {
      event.stopPropagation()
      const abrir = menu.hidden
      fechar()
      if (abrir) {
        menu.hidden = false
        botao.setAttribute("aria-expanded", "true")
        chevron?.classList.add("rotate-180")
      }
    })

    document.addEventListener("click", (event) => {
      if (!wrapper.contains(event.target)) fechar()
    })

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") fechar()
    })
  })
}

function initPasswordToggles() {
  document.querySelectorAll(".password-toggle").forEach((btn) => {
    if (btn.dataset.ligado) return
    btn.dataset.ligado = "1"
    btn.addEventListener("click", () => {
      const campo = document.getElementById(btn.dataset.target)
      if (!campo) return
      const mostrar = campo.type === "password"
      campo.type = mostrar ? "text" : "password"
      btn.textContent = mostrar ? "Ocultar" : "Mostrar"
      btn.setAttribute("aria-label", mostrar ? "Ocultar senha" : "Mostrar senha")
    })
  })
}

function initPreencherDemo() {
  const btn = document.getElementById("preencher-demo")
  if (!btn || btn.dataset.ligado) return
  btn.dataset.ligado = "1"
  btn.addEventListener("click", () => {
    const email = document.querySelector("input[type='email']")
    const senha = document.getElementById("password")
    if (email) email.value = "demo@clima.app"
    if (senha) senha.value = "demo123456"
  })
}

function initToasts() {
  document.querySelectorAll(".toast").forEach((toast) => {
    if (toast.dataset.ligado) return
    toast.dataset.ligado = "1"
    setTimeout(() => {
      toast.classList.add("toast-out")
      setTimeout(() => toast.remove(), 400)
    }, 4000)
  })
}

document.addEventListener("turbo:load", () => {
  initDropdowns()
  initPasswordToggles()
  initPreencherDemo()
  initToasts()
})
