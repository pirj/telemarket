migration 3, :create_companies do
  up do
    create_table :companies do
      column :id, Integer, serial: true

      column :identity_id, Integer
      column :name, String, length: 128

      column :campaign_name, Text
      column :instructions, Text
      column :manager_phone, String, length: 16

      column :created_at, DateTime
      column :updated_at, DateTime
      column :deleted_at, DateTime
    end
  end
end
