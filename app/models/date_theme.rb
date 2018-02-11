Sequel::Model.plugin :validation_helpers
class DateTheme < Sequel::Model
  one_to_many :answers

  def validate
    super
    validates_unique :date
  end
end
