class Answer < Sequel::Model
  many_to_one :user
  many_to_one :date_theme
end
