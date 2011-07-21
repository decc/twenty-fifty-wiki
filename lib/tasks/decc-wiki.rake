task :update_decc_wiki do
  `darcs push --all decc-wiki.greenonblack.com:decc-wiki`
  `ssh decc-wiki.greenonblack.com 'cd ~/decc-wiki; /usr/local/bin/rake-ruby-1.9.2-p0 db:migrate RAILS_ENV=production; touch tmp/restart.txt'`
end