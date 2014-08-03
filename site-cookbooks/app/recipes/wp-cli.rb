directory "/home/vagrant/.wp-cli" do
  owner "vagrant"
  group "vagrant"
  mode 00755
  action :create
end

cookbook_file "/home/vagrant/.wp-cli/config.yml" do
  source "wp-cli-config.yml"
  mode 0644
  owner "vagrant"
  group "vagrant"
end
