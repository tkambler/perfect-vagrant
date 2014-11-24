unless Vagrant.has_plugin?("vagrant-cachier")
    raise "`vagrant-cachier` is a required plugin. Install it by running: vagrant plugin install vagrant-cachier"
end

unless Vagrant.has_plugin?("vagrant-host-shell")
    raise "`vagrant-host-shell` is a required plugin. Install it by running: vagrant plugin install vagrant-host-shell"
end

unless Vagrant.has_plugin?("vagrant-hostsupdater")
    raise "`vagrant-hostsupdater` is a required plugin. Install it by running: vagrant plugin install vagrant-hostsupdater"
end
