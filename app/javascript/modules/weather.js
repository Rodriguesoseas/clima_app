const CHAVE_RECENTES = "clima_app.recentes"

let form = null
let input = null
let resultado = null
let recentesEl = null

function csrfToken() {
  const meta = document.querySelector("meta[name='csrf-token']")
  return meta ? meta.getAttribute("content") : ""
}

function clearElement(el) {
  while (el.firstChild) el.removeChild(el.firstChild)
}

function mostrarErro(mensagem) {
  clearElement(resultado)
  const div = document.createElement("div")
  div.className = "col-span-1 md:col-span-12"
  div.innerHTML = `
    <div class="glass flex items-center gap-5 border-red-500/20 p-8 animate-fade-up">
      <span class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-red-500/10 text-red-300">
        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/>
        </svg>
      </span>
      <div>
        <p class="font-semibold text-white">Não foi possível buscar o clima</p>
        <p class="mt-0.5 text-sm text-slate-400">${mensagem}</p>
      </div>
    </div>`
  resultado.appendChild(div)
}

function mostrarSkeleton() {
  const template = document.getElementById("skeleton-template")
  clearElement(resultado)
  if (template) {
    resultado.appendChild(template.content.cloneNode(true))
    return
  }
  const spinner = document.createElement("div")
  spinner.className = "col-span-1 md:col-span-12"
  spinner.textContent = "Carregando..."
  spinner.className += " text-center text-sm text-slate-500"
  resultado.appendChild(spinner)
}

function lerRecentes() {
  try {
    return JSON.parse(localStorage.getItem(CHAVE_RECENTES)) || []
  } catch (_e) {
    return []
  }
}

function salvarRecente(cidade) {
  const recentes = lerRecentes().filter((c) => c !== cidade)
  recentes.unshift(cidade)
  localStorage.setItem(CHAVE_RECENTES, JSON.stringify(recentes.slice(0, 6)))
  renderRecentes(recentes)
}

function renderRecentes(recentes) {
  if (!recentesEl) return
  clearElement(recentesEl)
  if (!recentes.length) return
  recentes.forEach((cidade) => {
    const btn = document.createElement("button")
    btn.type = "button"
    btn.className = "chip"
    btn.textContent = cidade
    btn.setAttribute("aria-pressed", "false")
    btn.addEventListener("click", () => {
      input.value = cidade
      buscar(cidade)
    })
    recentesEl.appendChild(btn)
  })
}

function initChipsPopulares() {
  document.querySelectorAll("#cidades-populares [data-cidade]").forEach((btn) => {
    if (btn.dataset.ligado) return
    btn.dataset.ligado = "1"
    btn.addEventListener("click", () => {
      const cidade = btn.dataset.cidade
      input.value = cidade
      buscar(cidade)
    })
  })
}

function initAtalhoBusca() {
  document.addEventListener("keydown", (event) => {
    const alvo = event.target
    const digitando =
      alvo && (alvo.tagName === "INPUT" || alvo.tagName === "TEXTAREA" || alvo.isContentEditable)

    if (event.key === "/" && !digitando) {
      event.preventDefault()
      input.focus()
    }

    if (event.key === "Escape" && document.activeElement === input) {
      input.value = ""
      input.blur()
    }
  })
}

async function buscar(cidade) {
  if (!cidade) {
    mostrarErro("Digite o nome de uma cidade válida.")
    return
  }

  mostrarSkeleton()

  try {
    const res = await fetch(`/buscar_clima?cidade=${encodeURIComponent(cidade)}`, {
      method: "GET",
      headers: {
        Accept: "text/html, application/json",
        "X-CSRF-Token": csrfToken()
      },
      credentials: "same-origin"
    })

    const contentType = res.headers.get("content-type") || ""

    if (!res.ok && contentType.includes("application/json")) {
      const data = await res.json()
      mostrarErro(data.erro || "Tente novamente em instantes.")
      return
    }

    const html = await res.text()
    resultado.innerHTML = html

    const cidadeEncontrada = resultado.querySelector("[data-cidade]")?.dataset.cidade
    if (cidadeEncontrada) salvarRecente(cidadeEncontrada)

    document.dispatchEvent(new CustomEvent("clima:atualizado", { detail: { raiz: resultado } }))
  } catch (_e) {
    mostrarErro("Não foi possível conectar ao servidor. Tente novamente.")
  }
}

export function initBusca() {
  form = document.getElementById("clima-form")
  input = document.getElementById("cidade")
  resultado = document.getElementById("resultado")
  recentesEl = document.getElementById("recentes")

  if (!form || !input || !resultado) return
  if (form.dataset.ligado) return
  form.dataset.ligado = "1"

  form.addEventListener("submit", (event) => {
    event.preventDefault()
    buscar(input.value.trim())
  })

  initChipsPopulares()
  initAtalhoBusca()
  renderRecentes(lerRecentes())
}

document.addEventListener("turbo:load", initBusca)
