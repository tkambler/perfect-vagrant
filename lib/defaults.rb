def checkServerDefaults(server)

    if !server.has_key?("paths")
        server["provider"] = {}
    end

    if !server.has_key?("provider")
        server["provider"] = "virtualbox"
    end

    if !server.has_key?("host_scripts")
        server["host_scripts"] = []
    end

    if !server.has_key?("host_port_forwarding")
        server["host_port_forwarding"] = []
    end

    if !server.has_key?("enabled")
        server["enabled"] = true
    end

    if !server.has_key?("autostart")
        server["autostart"] = true
    end

    return server

end

def checkDefaults(config)

    return config

end
