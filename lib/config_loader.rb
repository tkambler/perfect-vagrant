require 'json'

def loadConfig()

    config = {}
    config["override"] = {}
    config["override"]["servers"] = {}
    config["default"] = {}

    if File.exists?(File.expand_path "./config.json")
        config["override"] = JSON.parse(File.read(File.expand_path "./config.json"))
    end

    if File.exists?(File.expand_path "./config.default.json")
        config["default"] = JSON.parse(File.read(File.expand_path "./config.default.json"))
    end

    result = config["default"]

    if config["override"]["servers"]
        config["override"]["servers"].each do |key, value|
            value.each do |server_key, server_value|
                result["servers"][key][server_key] = server_value
            end
        end
    end

    config["override"].each do |key, value|
        if !key.eql?("servers")
            result[key] = value;
        end
    end

    if !result["provider"]
        result["provider"] = "virtualbox"
    end

    result["servers"].each do |key, server|
        if !server.has_key?("paths")
            server["paths"] = {}
        end
        if !server.has_key?("aliases")
            server["aliases"] = []
        end
        if !server.has_key?("timezone")
            server["timezone"] = "America/Chicago"
        end
        if !server.has_key?("cpus")
            server["cpus"] = 1
        end
        if !server.has_key?("memory")
            server["memory"] = 1024
        end
    end

    ENV["VAGRANT_DEFAULT_PROVIDER"] = result["provider"]

#     puts JSON.pretty_generate(result)
#     exit()

    return result

end
