resource "aws_instance" "ec2" {
  count                       = var.ec2_should_be_crated ? 1 : 0

  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  key_name                    = aws_key_pair.ec2_key_pair.key_name

  provisioner "file" {
    source      = "../modules/ec2/script/wait_for_instance.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.ec2_ssh_private_key_path)
  }



  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "ec2_security_group" {
  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description

  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ec2_security_group_name
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ec2_ssh_key_name
  public_key = file(var.ec2_ssh_public_key_path)
}

resource "local_file" "inventory" {
    filename = "/workspace/ansible/host.ini"
    content     = <<EOF
    [deployer]
    ${aws_instance.ec2[0].public_ip}

    [deployer:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
    ansible_ssh_user=ubuntu

    EOF
}

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i /workspace/ansible/host.ini --become --become-user=root /workspace/ansible/docker.yml
      ansible-playbook -i /workspace/ansible/host.ini --become --become-user=root /workspace/ansible/jenkins/jenkins.yml
      ansible-playbook -i /workspace/ansible/host.ini --become --become-user=root /workspace/ansible/waypoint.yml
    EOT
  }
  depends_on = ["local_file.inventory"]
}

