# Usuário de demonstração (troque e-mail/senha em produção).
demo = User.find_or_initialize_by(email: "demo@clima.app")
demo.password = "demo123456"
demo.password_confirmation = "demo123456"
demo.save!
