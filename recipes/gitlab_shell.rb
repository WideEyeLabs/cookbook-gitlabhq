# Clone gitlab shell
git node[:gitlab][:shell][:app_home] do
  repository node[:gitlab][:shell][:url]
  reference  node[:gitlab][:shell][:branch]
  action     :checkout
  user       node[:gitlab][:user]
  group      node[:gitlab][:group]
end

# Render gitlab shell config
template "#{node[:gitlab][:shell][:app_home]}/config.yml" do
  source 'gitlab_shell.yml.erb'
  owner  node[:gitlab][:user]
  group  node[:gitlab][:group]
  mode   0644
  variables(
    :git_user         => node[:gitlab][:user],
    :repos_path       => node[:gitlab][:shell][:repos_path],
    :auth_file        => node[:gitlab][:shell][:auth_file],
    :redis_binary     => node[:gitlab][:shell][:redis_binary_path],
    :redis_host       => node[:gitlab][:shell][:redis_host],
    :redis_port       => node[:gitlab][:shell][:redis_port],
    :redis_socket     => node[:gitlab][:shell][:redis_socket],
    :redis_namespace  => node[:gitlab][:shell][:redis_namespace]
  )
end

# Execute gitlab shell install script
execute 'gitlab-shell-install' do
  command "./bin/install && touch #{node[:gitlab][:marker_dir]}/.gitlab-shell-setup"
  cwd     node[:gitlab][:shell][:app_home]
  user    node[:gitlab][:user]
  group   node[:gitlab][:group]
  creates "#{node[:gitlab][:marker_dir]}/.gitlab-shell-setup"
end
