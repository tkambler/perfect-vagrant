vagrantCMD = ARGV[0]

require_relative "lib/config_global.rb"
require_relative "lib/required_plugins.rb"
require_relative "lib/config_virtualbox.rb"
require_relative "lib/config_loader.rb"
require_relative "lib/log_writer.rb"
require_relative "lib/defaults.rb"
require_relative "lib/on_exit.rb"
require_relative "lib/os_detector.rb"

local_config = loadConfig();
local_config = detectOS(local_config)

Vagrant.configure("2") do |config|

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
        config.cache.synced_folder_opts = {
            type: :nfs,
            mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
        }
    end

    local_config = checkDefaults(local_config)

    local_config["servers"].each do |server_id, server|

        server = checkServerDefaults(server)

        if !server["enabled"]
            next
        end

        config.vm.define server_id, primary: server["primary"], autostart: server["autostart"] do |instance|
            case local_config["provider"]
                when "virtualbox"
                    configVirtualBox(instance, server_id, server, local_config, config, vagrantCMD)
                else
                    puts "Error: Unknown provider specified: " + server["provider"]
            end
            configGlobal(instance, server, local_config, config)
        end

    end

end

at_exit {
    onExit(vagrantCMD, local_config)
}
