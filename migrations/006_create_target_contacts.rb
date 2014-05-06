migration 6, :create_target_contacts do
  up do
    create_table :target_contacts do
      column :id, Integer, serial: true

      column :target_id, Integer

      column :ceo, 'boolean', default: false
      column :name, String, length: 128
      column :phone, String, length: 16

      column :status, Integer

      column :result, String, length: 256

      column :added_by_operator_identity, Integer

      column :created_at, DateTime
      column :updated_at, DateTime
      column :deleted_at, DateTime
    end
  end
end
