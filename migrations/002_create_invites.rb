migration 2, :create_invites do
  up do
    create_table :invites do
      column :id, Integer, serial: true

      column :identity_id, Integer
      column :invitee_id, Integer
      column :code, String, length: 64
    end
  end
end
