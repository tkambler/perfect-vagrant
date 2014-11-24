def configGlobal(instance, server, local_config, config)

    if local_config["private_key_path"]
        config.ssh.private_key_path = local_config["private_key_path"]
    end

end
