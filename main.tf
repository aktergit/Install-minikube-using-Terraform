resource "aws_instance" "myec2" {
  ami                    = "ami-*****"
  instance_type          = "t2.medium"
  availability_zone      = "ca-central-1a"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "xyz"
  tags = {
    name = "minikube_ins"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
      "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp kubectl /usr/local/bin/kubectl",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = file("./xyzpem.pem")
    host        = self.public_ip
    }
  }
}
