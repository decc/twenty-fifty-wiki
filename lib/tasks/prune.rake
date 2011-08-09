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

desc "This task will flag all CostSource and CostCategory objects that don't have any cost data for deletion. This is NOT destructive."
task :flag_all_empty_cost_sources_and_cost_categories_for_deletion => :environment do
  [CostSource, CostCategory].each do |model|
    puts "Checking for empty #{model}s"
    model.all.each do |instance|
      if instance.costs.empty?
        puts "Flagging #{instance.title} for deletion"
        instance.content = "Delete"
        instance.save
      end
    end
  end
end

