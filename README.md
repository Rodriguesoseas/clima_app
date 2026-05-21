# Clima App

Aplicação web em Ruby on Rails para consultar o clima em tempo real de cidades no Brasil. O usuário precisa estar autenticado para buscar; cadastro e login usam e-mail e senha.

## Funcionalidades

- Cadastro de conta (`/cadastro`)
- Login e logout (`/login`, `/logout`)
- Busca de cidade com exibição de temperatura, vento e ícone da condição
- Geocodificação via [Nominatim](https://nominatim.org/) (OpenStreetMap)
- Dados meteorológicos via [Open-Meteo](https://open-meteo.com/)

## Stack

| Camada        | Tecnologia                          |
|---------------|-------------------------------------|
| Backend       | Ruby 3.2.2, Rails 7.1               |
| Banco         | PostgreSQL                          |
| Frontend      | ERB, Tailwind CSS 4, Hotwire Turbo  |
| JavaScript    | Importmap (sem bundler Node)         |
| Autenticação  | `has_secure_password` + sessão      |

## Como funciona

1. Visitante acessa a home e vê convite para login.
2. Após autenticar, informa o nome de uma cidade.
3. O backend resolve coordenadas no Nominatim (restrito ao Brasil na query).
4. Com latitude/longitude, consulta o Open-Meteo e devolve JSON.
5. O navegador monta o card de clima sem recarregar a página (`fetch` + Turbo desabilitado no formulário).

## Requisitos

- Ruby 3.2.2 (veja `.ruby-version`)
- PostgreSQL em execução
- Bundler

Credenciais padrão do banco em `config/database.yml`: usuário `postgres`, senha `postgres`, host `localhost`. Ajuste conforme seu ambiente.

## Instalação

```bash
git clone <url-do-repositorio>
cd clima_app
bin/setup
bin/rails db:seed
```

O script `bin/setup` instala gems, prepara o banco e limpa logs/temporários.

### Desenvolvimento

Com Tailwind em watch e servidor Rails:

```bash
bin/dev
```

Apenas o servidor (CSS já compilado):

```bash
bin/rails server
```

Acesse [http://localhost:3000](http://localhost:3000).

### Usuário de demonstração

Após `db:seed`:

| Campo   | Valor              |
|---------|--------------------|
| E-mail  | `demo@clima.app`   |
| Senha   | `demo123456`       |

Não use essas credenciais em produção.

## Testes

```bash
bin/rails test
```

Cobertura atual: fluxos de cadastro, página de login e integração básica de sessão.

## Rotas principais

| Método | Caminho          | Descrição              |
|--------|------------------|------------------------|
| GET    | `/`              | Home (busca se logado) |
| GET    | `/login`         | Formulário de login    |
| POST   | `/login`         | Autenticação           |
| DELETE | `/logout`        | Encerrar sessão        |
| GET    | `/cadastro`      | Novo usuário           |
| POST   | `/cadastro`      | Criar conta            |
| GET    | `/buscar_clima`  | API JSON (autenticada) |
| GET    | `/up`            | Health check           |

## Estrutura relevante

```
app/
  controllers/   # sessions, users, weather
  models/        # User
  services/      # WeatherService (APIs externas)
  views/         # layouts, formulários, home
  javascript/    # busca de clima no cliente
```

## APIs externas

- **Nominatim**: política de uso exige `User-Agent` identificável; o serviço envia `ClimaApp/1.0`.
- **Open-Meteo**: sem chave de API para uso básico de previsão atual.

Respeite limites de taxa do Nominatim em ambientes com muitos usuários.

## Produção

- Configure variáveis de banco via ambiente ou credenciais Rails.
- Defina `RAILS_MASTER_KEY` e rode `assets:precompile` antes do deploy.
- Revise `config/environments/production.rb` e não execute seeds com senhas de demonstração.

## Licença

Projeto de portfólio / estudo. Defina a licença desejada se for publicar o repositório.
