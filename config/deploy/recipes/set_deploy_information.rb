task :set_deploy_information do
  run "cd #{release_path} && RAILS_ENV='production' BRANCH='#{branch}' bundle exec rake leihs:set_deploy_information_footer --trace"
end