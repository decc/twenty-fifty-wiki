desc "This task will destructively and permanently remove all deleted pages"
task :destructively_remove_all_deleted_pages => :environment do
  [Page, Category, Picture, Cost, CostSource, CostCategory].each do |model|
    puts "Permanently removing deleted #{model}s"
    model.where(:deleted => true).all.each do |instance|
      puts "Permanently deleting #{instance.title}"
      instance.destroy
    end
  end
end

desc "This task will destructively and permanently remove the version history from all pages"
task :destructively_remove_all_version_history => :environment do
  [Page, Category, Picture, Cost, CostSource, CostCategory].each do |model|
    puts "Permanently removing version history from #{model}s"
    model.all.each do |instance|
      puts "Permanently removing version history from #{instance.title}"
      instance.versions[0...-1].each { |v| v.destroy }
    end
  end
end