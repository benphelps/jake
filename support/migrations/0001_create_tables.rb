# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      Integer :discord_id, null: false, unique: true
    end
    create_table :settings do
      primary_key :id
      foreign_key :user_id, :users, null: false
      String :key, null: false
      String :value, null: false
    end
  end

  down do
    drop_table(:users)
    drop_table(:settings)
  end
end
