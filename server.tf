variable "digitalocean_token" {}

output "ip" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "default"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
  image = "ubuntu-16-04-x64"
  name = "exportgifsound-test"
  region = "nyc3"
  size = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yes | apt-get install python"
    ]
  }
}
