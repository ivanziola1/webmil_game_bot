Sequel.migration do
  change do
    create_table(:date_themes) do
      primary_key :id
      String :theme
      Date :date
    end
  end
end
