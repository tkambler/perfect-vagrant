def configVirtualBox(instance, server, local_config, config)

    instance.vm.provider "virtualbox" do |v|

        v.name = server["id"]

        if !server["cpus"]
            v.customize [ "modifyvm", :id, "--cpus", "1" ]
        else
            v.customize [ "modifyvm", :id, "--cpus", server["cpus"] ]
        end

        if !server["memory"]
            v.customize [ "modifyvm", :id, "--memory", "512" ]
        else
            v.customize [ "modifyvm", :id, "--memory", server["memory"] ]
        end

        v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
        v.customize [ "setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate//opt", "1" ]

    end

    # Set box based on configuration. Defaults to `ubuntu/precise64`
    if !server["box"]
        instance.vm.box = "ubuntu/precise64"
    else
        instance.vm.box = server["box"]
        instance.vm.box_url = server["box_url"]
    end

    # Set IP Address
    instance.vm.network :private_network, ip: server["guest_ip"]

    # Setup port forwarding
    server["host_port_forwarding"].each do |ports|
        instance.vm.network :forwarded_port, guest: ports["guest"], host: ports["host"]
    end

    # Enable SSH agent forwarding
    config.ssh.forward_agent = true

    # Run provisioning scripts
    # Global
    server["host_scripts"].each do |script, key|
        instance.vm.provision :host_shell do |host_shell|
            host_shell.inline = './host_scripts/' + script
        end
    end

    instance.hostsupdater.aliases = server["aliases"]


    # Loop through configured path maps.
    server["paths"].each do |local_path, remote_path|
        instance.vm.synced_folder local_path, remote_path, type: "nfs", nfs_udp: true, create: true
    end

    if server["guest_hostname"]
        instance.vm.hostname = server["guest_hostname"]
    end

    # Guest provisioning

    # ngrok
    local_config["servers"].each do |tsk, this_server|
        if this_server["ngrok_token"]
            ngrok_cmd = "echo \"auth_token: " + this_server["ngrok_token"] + "\" >> ~/.ngrok"
            config.vm.provision "shell", inline: ngrok_cmd
            ngrok_cmd = "echo \"auth_token: " + this_server["ngrok_token"] + "\" >> /home/vagrant/.ngrok; chown vagrant:vagrant /home/vagrant/.ngrok"
            config.vm.provision "shell", inline: ngrok_cmd
        end
    end

    # Timezone
    local_config["servers"].each do |tsk, this_server|
        if this_server["timezone"]
            timezone_cmd = "mv /etc/localtime /etc/localtime.bak; ln -sf /usr/share/zoneinfo/" + this_server["timezone"] + " /etc/localtime"
            config.vm.provision "shell", inline: timezone_cmd
        end
    end

    local_config["servers"].each do |tsk, this_server|
        hostname_cmd = "echo \"" + this_server["guest_ip"] + " " + this_server["guest_hostname"] + "\" >> /etc/hosts"
        config.vm.provision "shell", inline: hostname_cmd
    end

    if local_config.has_key?("hosts")
        local_config["hosts"].each do |this_host, this_ip|
            hostname_cmd = "echo \"" + this_ip + " " + this_host + "\" >> /etc/hosts"
            config.vm.provision "shell", inline: hostname_cmd
        end
    end

    if File.file?(ENV['HOME'] + "/.gitconfig")
        instance.vm.provision "file", source: ENV['HOME'] + "/.gitconfig", destination: "/home/vagrant/.gitconfig"
        instance.vm.provision "file", source: ENV['HOME'] + "/.gitconfig", destination: "/tmp/.gitconfig"
        instance.vm.provision "shell", inline: "sudo mv /tmp/.gitconfig /root/.gitconfig && chown root:root /root/.gitconfig"
    else
        puts ENV['HOME'] + "/.gitconfig not found"
    end

    if (server.has_key?("github_private_key_file") && !server["github_private_key_file"].nil? && !server["github_private_key_file"].empty?)
        instance.vm.provision "file", source: server["github_private_key_file"], destination: "/home/vagrant/.ssh/id_rsa"
        instance.vm.provision "file", source: server["github_private_key_file"], destination: "/tmp/id_rsa"
        instance.vm.provision "shell", inline: "chown vagrant:vagrant /home/vagrant/.ssh/id_rsa"
        instance.vm.provision "shell", inline: "sudo mv /tmp/id_rsa /root/.ssh/id_rsa && sudo chown root:root /root/.ssh/id_rsa && sudo chmod 600 /root/.ssh/id_rsa"
    end

    # Box-specific
    if server.has_key?("scripts")
        server["scripts"].each do |script, key|
            if script.is_a?(String)
                serverScript = "/vagrant/scripts/" + script + " 2&>1 >> /vagrant/provision.log"
                instance.vm.provision "shell", inline: serverScript
            else
                if script.has_key?("inline")
                    if script.has_key?("run") && script["run"] === "always"
                        config.vm.provision "shell", run: "always" do |s|
                            s.inline = script["inline"]
                        end
                    else
                        instance.vm.provision "shell", inline: script["inline"]
                    end
                else
                    serverScript = "/vagrant/scripts/" + script["script"] + " 2&>1 >> /vagrant/provision.log"
                    if script.has_key?("run") && script["run"] === "always"
                        config.vm.provision "shell", run: "always" do |s|
                            s.inline = serverScript
                        end
                    else
                        serverScript = "/vagrant/scripts/" + script["script"] + " 2&>1 >> /vagrant/provision.log"
                        instance.vm.provision "shell", inline: serverScript
                    end
                end
            end
        end
    end

end
