migration 1, :create_identities do
  up do
    create_table :identities do
      column :id, Integer, serial: true

      column :email, String, length: 127
      column :crypted_password, String, length: 60
      column :role, String, length: 20
      column :name, String, length: 100

      column :created_at, DateTime
      column :updated_at, DateTime
      column :deleted_at, DateTime
    end
  end
end
