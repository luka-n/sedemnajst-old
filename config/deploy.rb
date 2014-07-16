# config valid only for Capistrano 3.1
lock "3.2.1"

set :application, "sedemnajst"
set :repo_url, "https://github.com/lnovsak/sedemnajst.git"
set :deploy_to, "/home/sedemnajst"
set :log_level, :info

set :default_env, "TZ" => "Europe/Ljubljana"

set :linked_files, %w{config/database.yml config/config.yml
                      config/thinking_sphinx.yml config/secrets.yml
                      config/production.sphinx.conf}

set :linked_dirs, %w{log tmp db/sphinx public/avatars public/assets
                     vendor/bundle}

set :bundle_binstubs, nil
set :bundle_path, -> { shared_path.join("vendor/bundle") }

set :rbenv_type, :user
set :rbenv_ruby, "2.1.2"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
