# Configure WP-CLI
bash "wp-cli-conf" do
  code <<-EOH
    mkdir /home/vagrant/.wp-cli
  EOH
end

cookbook_file "/home/vagrant/.wp-cli/config.yml" do
  source "config.yml"
  mode 0644
  owner "vagrant"
  group "vagrant"
end
