const TEMAS_VALIDOS = new Set(["sol", "noite", "nublado", "neblina", "chuva", "neve", "tempestade"])

function aplicarTema(raiz) {
  const tema = raiz?.querySelector("[data-weather]")?.dataset.weather
  if (tema && TEMAS_VALIDOS.has(tema)) {
    document.body.dataset.weather = tema
  }
}

document.addEventListener("turbo:load", () => {
  const raiz = document.getElementById("resultado")
  if (raiz?.querySelector("[data-weather]")) {
    aplicarTema(raiz)
  } else {
    delete document.body.dataset.weather
  }
})

document.addEventListener("clima:atualizado", (event) => {
  aplicarTema(event.detail?.raiz)
})
