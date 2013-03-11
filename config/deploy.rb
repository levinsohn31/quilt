set :application, "quilt"
set :repository,  "git@github.com:janrain/quilt.git"
set :branch, "master"
set :scm, 'git'
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :system

require "rvm/capistrano"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

server "quilt.janrain.com", :app, :web
set :deploy_to, "/var/www/#{application}"

set(:user) do
   Capistrano::CLI.ui.ask "Puppet User: "
end

namespace :deploy do
  desc "Start Thin"
  task :start do
    run "cd /var/www/quilt/current && thin start -C quilt.yml"
  end

  desc "Stop Thin"
  task :stop do
    run "cd /var/www/quilt/current && thin stop -C quilt.yml"
  end

  desc "Restart Thin"
  task :restart do
   run "cd /var/www/quilt/current && thin restart -C quilt.yml"
  end
  
  desc "Copy the generated Quilt assets to the shared asset folder."
  task :copy_assets do
  	version = capture("cd #{release_path} && rake vinfo:show | tr -d '\n'")
  	#raise version.inspect
  	run "cd #{release_path}/public/ && rm -rf assets && mv #{version} assets && ln -s assets #{version}"
    run "cd #{release_path}/app/assets/images/icons && cp -r * #{release_path}/public/assets/icons/"
  end
  
  desc "Create symlinks for syntaxhighlighter"
  task :create_syntaxhighlighter_symlink do
  	run "ln -s #{current_path}/vendor/assets/javascripts/syntaxHighlighter/ #{current_path}/public/assets/syntaxHighlighter"
	end
end
after 'deploy:create_symlink', 'deploy:create_syntaxhighlighter_symlink'
after 'deploy:assets:precompile', 'deploy:copy_assets'