require 'title'

class UpdateTitles < Struct.new(:old_title, :new_title)
  def perform
    Title.pages_that_use(old_title,new_title).each do |model_to_update|
      model_to_update.update_links_to if model_to_update.respond_to?(:update_links_to)
      model_to_update.update_category_membership if model_to_update.respond_to?(:update_category_membership)
    end
  end
end