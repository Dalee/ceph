Vagrant.require_version ">= 1.8.0"
Vagrant.configure("2") do |config|

	config.vm.box = "Dalee/ubuntu"
	config.vm.provider :virtualbox do |v|
		v.memory = 2048
		v.cpus = 2
	end

	project_root = "/home/web/ceph"
	project_name = "ceph"

	config.vm.network "private_network", type: "dhcp"
	config.vm.synced_folder ".", project_root, type: "nfs"

	config.vm.provision "shell", path: "build/ansible/scripts/vagrant-fix.sh"
	config.vm.provision "shell", path: "build/ansible/scripts/vagrant-ansible.sh",
		env: {
			"PROJECT_ROOT": project_root,
			"PROJECT_NAME": project_name,
		},
		keep_color: true
end
