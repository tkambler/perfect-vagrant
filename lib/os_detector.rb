require "rbconfig"

##
# @todo - Doesn't detect Linux.
def detectOS(config)
    if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
        config["host_os"] = "win"
    else
        config["host_os"] = "osx"
    end
    return config
end
