Given /^A page with title "([^\"]*)" and content "([^\"]*)"$/i do |title, content|
  p = Page.create!(:title => title, :content => content)
end

Given /^A home page$/i do
  Given %{A page with title "this is the home page" and content "this is the home page"}
end