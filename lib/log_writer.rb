if !File.exists?("provision.log")
    File.open("provision.log", "w") {}
end
