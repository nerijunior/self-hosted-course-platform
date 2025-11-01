User.create!(
  email_address: 'neri@nerijunior.com',
  password_digest: BCrypt::Password.create('123qweasd')
)

# c = Course.create!(name: "Primeiro Curso")
# u = Unit.create!(course: c, name: "Primeira unidade")
# l = Lesson.create!(course: c, unit: u, name: "Primeira aula", filename: 'arquivo.mp4')
