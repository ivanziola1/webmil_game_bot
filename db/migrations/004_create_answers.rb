Sequel.migration do
  change do
    create_table(:answers) do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :date_theme_id, :date_themes
      String :file_id
      BigDecimal :score
    end
  end
end
