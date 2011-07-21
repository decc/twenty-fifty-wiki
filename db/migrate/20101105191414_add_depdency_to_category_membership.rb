class AddDepdencyToCategoryMembership < ActiveRecord::Migration
  def self.up
    add_column :category_memberships, :dependency, :string
  end

  def self.down
    remove_column :category_memberships, :dependency
  end
end
