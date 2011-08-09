desc "This task will destructively and permanently remove all deleted pages"
task :remove_all_deleted_pages => :environment do
  [Page, Category, Picture, Cost, CostSource, CostCategory].each do |model|
    puts "Permanently removing deleted #{model}s"
    model.where(:deleted => true).all.each do |instance|
      puts "Permanently deleting #{instance.title}"
      instance.destroy
    end
  end
end