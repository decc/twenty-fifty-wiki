module Searchable
  def self.included(base)
    base.instance_eval do
      searchable do
        text :title, :default_boost => 2
        text :content, :stored => true
      end
    end
  end
end