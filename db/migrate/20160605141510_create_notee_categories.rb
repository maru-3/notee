class CreateNoteeCategories < ActiveRecord::Migration
  class NoteeCategory < ActiveRecord::Base; end

  def change
    create_table :notee_categories do |t|

      t.string  :name, null: false, default: "category_name"
      t.string  :slug, uniqueness: true
      t.integer :parent_id
      t.boolean :is_private, null: false, default: false
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :notee_categories, :slug, :unique => true

  end
end
