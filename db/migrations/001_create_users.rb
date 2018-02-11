Sequel.migration do
  change do
    create_table(:users) do
      Integer :id, primary_key: true
      String :username
      String :first_name
      String :last_name
      String :language_code
    end
  end
end
