class CreateAuditTrails < ActiveRecord::Migration
  def change
    create_table :audit_trails do |t|
      t.boolean :success, default: true
      t.text    :message
      t.integer :auditable_id
      t.string  :auditable_type
      t.integer :user_id

      t.timestamps
    end
  end
end