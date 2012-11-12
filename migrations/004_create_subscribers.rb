migration 4, :create_subscribers do
  up do
    create_table :subscribers do
      column :id, Integer, serial: true

      column :email, String, length: 128

      column :created_at, DateTime
      column :updated_at, DateTime
      column :deleted_at, DateTime
    end
  end
end
