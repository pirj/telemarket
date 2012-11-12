migration 5, :create_targets do
  up do
    create_table :targets do
      column :id, Integer, serial: true

      column :company_id, Integer
      column :name, String, length: 128

      column :status, Integer

      column :created_at, DateTime
      column :updated_at, DateTime
      column :deleted_at, DateTime
    end
  end
end
