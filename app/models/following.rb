class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  validates_uniqueness_of :user_id, :scope => [:target_type,:target_id]
end
