def onExit(vagrant_command, config)

    case vagrant_command

    when "up"

        config["servers"].each do |server_id, server|
            if server["open_url"] && config["provider"] == "virtualbox"
                if config["host_os"] == "osx"
                    system("open " + server["open_url"])
                elsif config["host_os"] = "win"
                    system("cmd /c start " + server["open_url"])
                end
            end
        end

    end

end
