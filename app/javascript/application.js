import "@hotwired/turbo-rails"
import "controllers"

function csrfToken() {
  const meta = document.querySelector("meta[name='csrf-token']")
  return meta ? meta.getAttribute("content") : ""
}

function clearElement(el) {
  while (el.firstChild) el.removeChild(el.firstChild)
}

function appendError(parent, text) {
  const p = document.createElement("p")
  p.className = "error-box"
  p.textContent = text
  parent.appendChild(p)
}

function weatherIcon(code) {
  const icons = {
    0: "☀️",
    1: "🌤️",
    2: "⛅",
    3: "☁️",
    45: "🌫️",
    48: "🌫️",
    51: "🌦️",
    53: "🌦️",
    55: "🌧️",
    61: "🌧️",
    63: "🌧️",
    65: "🌧️",
    71: "🌨️",
    73: "🌨️",
    75: "🌨️",
    80: "🌦️",
    81: "🌧️",
    82: "⛈️",
    95: "⛈️",
    96: "⛈️",
    99: "⛈️"
  }
  return icons[code] || "🌡️"
}

function renderWeatherCard(data) {
  const card = document.createElement("section")
  card.className = "glass p-8 md:p-12 lg:p-16"

  const grid = document.createElement("div")
  grid.className = "grid items-center gap-8 lg:grid-cols-2"

  const info = document.createElement("div")
  info.className = "space-y-4"

  const label = document.createElement("p")
  label.className = "text-sm font-medium uppercase tracking-wider text-slate-400"
  label.textContent = "Condição atual"
  info.appendChild(label)

  const city = document.createElement("h2")
  city.className = "text-3xl font-bold tracking-tight text-white md:text-4xl"
  city.textContent = data.cidade
  info.appendChild(city)

  const temp = document.createElement("p")
  temp.className = "text-6xl font-bold tabular-nums text-white md:text-8xl"
  temp.textContent = `${data.temperatura}°C`
  info.appendChild(temp)

  const wind = document.createElement("span")
  wind.className = "inline-flex rounded-full bg-white/10 px-4 py-2 text-sm text-slate-300"
  wind.textContent = `Vento: ${data.vento} km/h`
  info.appendChild(wind)

  const iconWrap = document.createElement("div")
  iconWrap.className = "flex justify-center text-8xl md:text-9xl"
  iconWrap.setAttribute("aria-hidden", "true")
  iconWrap.textContent = weatherIcon(data.weathercode)

  grid.appendChild(info)
  grid.appendChild(iconWrap)
  card.appendChild(grid)

  return card
}

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("clima-form")
  const input = document.getElementById("cidade")
  const resultado = document.getElementById("resultado")

  if (!form || !input || !resultado) return

  form.addEventListener("submit", async (event) => {
    event.preventDefault()

    const cidade = input.value.trim()
    clearElement(resultado)

    if (!cidade) {
      appendError(resultado, "Digite uma cidade válida.")
      return
    }

    try {
      const res = await fetch(`/buscar_clima?cidade=${encodeURIComponent(cidade)}`, {
        method: "GET",
        headers: {
          Accept: "application/json",
          "X-CSRF-Token": csrfToken()
        },
        credentials: "same-origin"
      })

      const data = await res.json()

      if (!res.ok && data.erro) {
        appendError(resultado, data.erro)
        return
      }

      if (data.erro) {
        appendError(resultado, data.erro)
        return
      }

      resultado.appendChild(renderWeatherCard(data))
    } catch (_e) {
      appendError(resultado, "Não foi possível conectar ao servidor. Tente novamente.")
    }
  })
})
