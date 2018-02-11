Sequel.migration do
  change do
    alter_table(:users) do
      add_column(:active, TrueClass)
      set_column_default(:active, true)
    end
  end
end
