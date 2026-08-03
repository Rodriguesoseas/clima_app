# Pin npm packages by running ./bin/importmap

pin "application"
pin "modules/weather", to: "modules/weather.js"
pin "modules/theme", to: "modules/theme.js"
pin "modules/motion", to: "modules/motion.js"
pin "modules/ui", to: "modules/ui.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
