module WeatherHelper
  CONDICOES = {
    0 => "Céu limpo",
    1 => "Predominantemente limpo",
    2 => "Parcialmente nublado",
    3 => "Encoberto",
    45 => "Nevoeiro",
    48 => "Nevoeiro com geada",
    51 => "Garoa leve",
    53 => "Garoa",
    55 => "Garoa intensa",
    61 => "Chuva leve",
    63 => "Chuva",
    65 => "Chuva forte",
    71 => "Neve leve",
    73 => "Neve",
    75 => "Neve intensa",
    80 => "Pancadas de chuva",
    81 => "Pancadas de chuva",
    82 => "Pancadas violentas",
    95 => "Tempestade",
    96 => "Tempestade com granizo",
    99 => "Tempestade com granizo"
  }.freeze

  DIAS_SEMANA = %w[dom seg ter qua qui sex sab].freeze
  DIRECOES = %w[N NE L SE S SO O NO].freeze

  ICONES = {
    sol: %(<circle cx="12" cy="12" r="4.5"/><path d="M12 2.2v2M12 19.8v2M2.2 12h2M19.8 12h2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>),
    lua: %(<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/>),
    sol_nuvem: %(<circle cx="8" cy="7.5" r="3.5"/><path d="M8 1.5V3M1.5 7.5H3M3.3 2.8l1.1 1.1M12.7 2.8l-1.1 1.1"/><path d="M6.5 21h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/>),
    lua_nuvem: %(<path d="M17.5 13.5a4.5 4.5 0 0 0-.7-8.9 6.5 6.5 0 1 1-9.6 5.9 4 4 0 0 0 2.3 8h9.5a4.5 4.5 0 0 0-1.5-5Z"/>),
    nuvem: %(<path d="M6.5 18.5h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/>),
    neblina: %(<path d="M6.5 10.5h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99A4 4 0 0 0 6.5 10.5Z"/><path d="M5 14.5h14M7.5 17.5h9M5.5 20.5h13"/>),
    garoa: %(<path d="M6.5 12.5h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/><path d="M8.5 16.5v2M12 16.5v2M15.5 16.5v2"/>),
    chuva: %(<path d="M6.5 12h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/><path d="M8.5 15.5v3.5M12 15.5v3.5M15.5 15.5v3.5"/>),
    neve: %(<path d="M6.5 11.5h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/><path d="M9 16.5v3M7.5 18l3-1.5M10.5 18 7.5 19.5M15 16.5v3M13.5 18l3-1.5M16.5 18l-3 1.5"/>),
    tempestade: %(<path d="M6.5 12.5h9.5a4.5 4.5 0 0 0 .4-8.99 6.5 6.5 0 0 0-12.3.99 4 4 0 0 0 2.4 8Z"/><path d="M12 13.5 9.8 17.5h2.1L10.4 22l5.3-6.4h-2.4l2.4-2.1h-3.7Z"/>),
    nascer: %(<path d="M4 21h16"/><path d="M12 13.5a3.5 3.5 0 0 1 3.5 3.5h-7A3.5 3.5 0 0 1 12 13.5Z"/><path d="M12 13.5V7.5M8.6 9.9 7.2 8.5M15.4 9.9l1.4-1.4"/>),
    por: %(<path d="M4 21h16"/><path d="M12 13.5a3.5 3.5 0 0 1 3.5 3.5h-7A3.5 3.5 0 0 1 12 13.5Z"/><path d="M12 7.5v2M8.6 9.9 7.2 8.5M15.4 9.9l1.4-1.4"/>),
    vento: %(<path d="M3 8h9.5a2 2 0 1 0-2-2M3 12h13.5a2 2 0 1 1-2 2M3 16h8a2 2 0 1 1-2 2"/>),
    umidade: %(<path d="M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11Z"/>),
    pressao: %(<path d="M12 14a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"/><path d="M12 14l3.5-3.5M5 19a9 9 0 1 1 14 0"/>),
    uv: %(<circle cx="12" cy="12" r="4"/><path d="M12 2v2m0 16v2M2 12h2m16 0h2M4.9 4.9l1.4 1.4m11.4 11.4 1.4 1.4M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>),
    termometro: %(<path d="M14 14.76V5a2 2 0 1 0-4 0v9.76a4 4 0 1 0 4 0Z"/><path d="M12 9v5"/>),
    gota: %(<path d="M12 2.5s6 6.8 6 11.3a6 6 0 0 1-12 0C6 9.3 12 2.5 12 2.5Z"/><path d="M12 16.5a2.5 2.5 0 0 0-2.5 2.5"/>)
  }.freeze

  CIDADES_POPULARES = ["São Paulo", "Rio de Janeiro", "Belo Horizonte", "Brasília", "Curitiba", "Salvador", "Recife", "Porto Alegre"].freeze

  def cidades_populares
    CIDADES_POPULARES
  end

  def weather_icon(code, is_day: true, **opcoes)
    nome = case code
           when 0 then is_day ? :sol : :lua
           when 1, 2 then is_day ? :sol_nuvem : :lua_nuvem
           when 3 then :nuvem
           when 45, 48 then :neblina
           when 51..57 then :garoa
           when 61..67, 80..82 then :chuva
           when 71..77, 85, 86 then :neve
           when 95..99 then :tempestade
           else :nuvem
           end

    icone_weather(nome, **opcoes)
  end

  def icone_weather(nome, **opcoes)
    nome = nome.to_sym
    return "" unless ICONES.key?(nome)

    tag.svg(
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      stroke_width: "1.8",
      stroke_linecap: "round",
      stroke_linejoin: "round",
      class: opcoes[:class] || "h-6 w-6",
      aria: { hidden: true }
    ) do
      ICONES[nome].html_safe
    end
  end

  def condicao_texto(code)
    CONDICOES.fetch(code.to_i, "Condição desconhecida")
  end

  def tema_ambiente(code, is_day)
    case code
    when 0, 1, 2 then is_day ? "sol" : "noite"
    when 3 then "nublado"
    when 45, 48 then "neblina"
    when 51..67, 80..82 then "chuva"
    when 71..77, 85, 86 then "neve"
    when 95..99 then "tempestade"
    else "nublado"
    end
  end

  def nome_dia(data, indice)
    return "Hoje" if indice.zero?

    DIAS_SEMANA[Date.parse(data).wday].capitalize
  end

  def direcao_vento(deg)
    return "" if deg.nil?

    DIRECOES[((((deg % 360) + 360) % 360) / 45.0).round % 8]
  end

  def nivel_uv(uv)
    return "" if uv.nil?

    if uv <= 2 then "Baixo"
    elsif uv <= 5 then "Moderado"
    elsif uv <= 7 then "Alto"
    elsif uv <= 10 then "Muito alto"
    else "Extremo"
    end
  end

  def pct_barra(valor, maximo)
    [[(valor.to_f / maximo * 100), 0].max, 100].min.round(1)
  end
end
