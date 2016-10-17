variable "digitalocean_token" {}

provider "digitalocean" {
    token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "default" {
    name = "exportgifsound-test"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
	image = "ubuntu-16-04-x64"
    name = "exportgifsound-test"
    region = "nyc2"
    size = "512mb"
    ssh_keys = [ "${digitalocean_ssh_key.default.id}" ]

	connection {
		private_key = "${file("~/.ssh/id_rsa")}"
	}

    provisioner "remote-exec" {
        inline = [
		  "sudo apt-get install software-properties-common",
		  "sudo yes | apt-add-repository ppa:ansible/ansible",
		  "sudo apt-get update",
		  "sudo yes | apt-get install ansible",
        ]
    }

    provisioner "file" {
        source = "server.yml"
        destination = "~/server.yml"
    }

    provisioner "remote-exec" {
        inline = [
		  "ansible-playbook -i \"localhost,\" -c local ~/server.yml"
        ]
    }
}