class AddDefaultQuestionsToCostCategories < ActiveRecord::Migration
  def self.up
    add_column :cost_categories, :cost_boilerplate, :text
  end

  def self.down
    remove_column :cost_categories, :cost_boilerplate
  end
end
