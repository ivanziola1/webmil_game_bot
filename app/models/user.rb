class User < Sequel::Model
  one_to_many :answers
  unrestrict_primary_key # bad?

  dataset_module do
     def active
       where(active: true)
     end
  end

  def inactive?
    active == false
  end

  def activate!
    update(active: true)
  end

  def deactivate!
    update(active: false)
  end
end
