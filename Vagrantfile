# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings
#################################

# IP Address for the host only network, change it to anything you like
# but please keep it within the IPv4 private network range
ip_address = "172.22.22.22"

# The project name is base for directories, hostname and alike
project_name = "projectname"

# MySQL and PostgreSQL password - feel free to change it to something
# more secure (Note: Changing this will require you to update the index.php example file)
database_password = "root"

# Vagrant configuration
#################################

Vagrant.configure("2") do |config|
  # Enable Berkshelf support
  config.berkshelf.enabled = true

  # Use the omnibus installer for the latest Chef installation
  config.omnibus.chef_version = :latest

  # Define VM box to use
  config.vm.box = "precise32"
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Set share folder
  config.vm.synced_folder "./theme" , "/home/vagrant/theme/", :mount_options => ["dmode=777", "fmode=666"]

  # Use hostonly network with a static IP Address and enable
  # hostmanager so we can have a custom domain for the server
  # by modifying the host machines hosts file
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.define project_name do |node|
    node.vm.hostname = project_name + ".local"
    node.vm.network :private_network, ip: ip_address
    node.hostmanager.aliases = [ "www." + project_name + ".local" ]
  end
  config.vm.provision :hostmanager

  # Enable and configure chef solo
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "app::packages"
    chef.add_recipe "app::web_server"
    chef.add_recipe "app::vhost"
    chef.add_recipe "app::wp-cli"
    #chef.add_recipe "memcached"
    chef.add_recipe "app::db"
    chef.json = {
      :app => {
        # Project name
        :name           => project_name,

        # Name of MySQL database that should be created
        :db_name        => "dbname",

        # Server name and alias(es) for Apache vhost
        :server_name    => project_name + ".local",
        :server_aliases =>  [ "www." + project_name + ".local" ],

        # Document root for Apache vhost
        :docroot        => "/var/www/" + project_name,

        # General packages
        :packages   => %w{ vim git screen curl },
        
        # PHP packages
        :php_packages   => %w{ php5-mysqlnd php5-curl php5-mcrypt php5-gd }
      },
      :mysql => {
        :server_root_password   => database_password,
        :server_repl_password   => database_password,
        :server_debian_password => database_password,
        :bind_address           => ip_address,
        :allow_remote_root      => true
      }
    }
  end
end
