class CreateAuditYears < ActiveRecord::Migration
  def change
    create_table :audit_years do |t|
      t.integer :year

      t.timestamps
    end
  end
end