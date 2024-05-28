resource "tls_private_key" "private_key" {
  for_each = toset(var.ec2_instances)
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  for_each = toset(var.ec2_instances)
  key_name   = "${var.common_prefix}-${each.key}"
  public_key = tls_private_key.private_key[each.key].public_key_openssh
}

resource "local_file" "private_key" {
  for_each = toset(var.ec2_instances)

  content  = tls_private_key.private_key[each.key].private_key_openssh
  filename = "${local.ssh_generation_folder}/${each.key}/ssh.key"
  file_permission = "0600"
}



resource "local_file" "instance_address" {
  for_each = toset(var.ec2_instances)
  depends_on = [ aws_instance.cilium-workshop-instance ]
  content  = aws_instance.cilium-workshop-instance[each.key].public_dns
  filename = "${local.ssh_generation_folder}/${each.key}/instance-address"
  file_permission = "0600"
}

resource "local_file" "create_scripts" {
  depends_on = [ aws_instance.cilium-workshop-instance ]
  for_each = {for script in local.local_scripts_to_copy: script.key => script }
  content  = each.value.content
  filename = each.value.filename
}


data "archive_file" "distribution_zip" {
    for_each = toset(var.ec2_instances)
    depends_on = [ local_file.create_scripts ]
    output_path = "${local.distribution_folder}/${each.key}/${each.key}.zip"
    source_dir = "${local.ssh_generation_folder}/${each.key}"
    type = "zip"
}

resource "null_resource" "distribution_tar_gz" {
  #archive_file ne supporte pas les tar.gz, donc petit hack pour générer des tar.gz...
  for_each = toset(var.ec2_instances)
  depends_on = [ local_file.create_scripts, data.archive_file.distribution_zip ]
  triggers = {
    file_changed = md5("$distribution_folder/${each.key}/${each.key}.zip")
  }
  provisioner "local-exec" {
    command = <<EOT
      distribution_folder="$(cd "${local.distribution_folder}" && pwd)"
      cd "${local.ssh_generation_folder}/${each.key}/${each.key}"
      
      tar cvzf - . > "$distribution_folder/${each.key}.tar.gz"
    EOT
  }
}


resource "aws_security_group" "cilium-workshop-instance-security-group" {
  for_each = toset(var.ec2_instances)
  vpc_id = data.aws_vpc.default.id
  name        = "cilium-workshop-security-group-${var.common_prefix}-${each.key}"
  description = "Security group for Cilium Workshop"
  tags = {
    Name = "Cilium Workshop"
  }
}


resource "aws_vpc_security_group_ingress_rule" "cilium-workshop-instance-ingress-rule-ssh" {
  for_each = toset(var.ec2_instances)
  security_group_id = aws_security_group.cilium-workshop-instance-security-group[each.key].id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


resource "aws_vpc_security_group_ingress_rule" "cilium-workshop-instance-ingress-rule-http" {
  for_each = toset(var.ec2_instances)
  security_group_id = aws_security_group.cilium-workshop-instance-security-group[each.key].id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}



resource "aws_vpc_security_group_ingress_rule" "cilium-workshop-instance-ingress-rule-https" {
  for_each = toset(var.ec2_instances)
  security_group_id = aws_security_group.cilium-workshop-instance-security-group[each.key].id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "cilium-workshop-instance-egress-rule-http" {
  for_each = toset(var.ec2_instances)
  security_group_id = aws_security_group.cilium-workshop-instance-security-group[each.key].id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "cilium-workshop-instance-egress-rule-https" {
  for_each = toset(var.ec2_instances)
  security_group_id = aws_security_group.cilium-workshop-instance-security-group[each.key].id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}


resource "aws_instance" "cilium-workshop-instance" {
  for_each = toset(var.ec2_instances)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.generated_key[each.key].key_name

  security_groups = [aws_security_group.cilium-workshop-instance-security-group[each.key].name]
  tags = {
    Name = "Workshop Cilium - ${var.common_prefix}-${each.key}"
    Prefix = var.common_prefix
    Instance = each.key
  }

  user_data = file("${path.module}/machine-config-scripts/init-install.sh")
  user_data_replace_on_change = true

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/workshop",
      "mkdir ~/.kube"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key[each.key].private_key_openssh
      host        = "${self.public_dns}"
    }
  }
}


resource null_resource "copy_workspace" {
  depends_on = [ aws_instance.cilium-workshop-instance ]
  for_each = {for workspace_dirs in local.workspace_dirs_to_copy: workspace_dirs.key => workspace_dirs }
  
  provisioner "file" {
    source      = "${each.value.folder}"
    destination = "/home/ubuntu/workshop"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key[each.value.instance].private_key_openssh
      host        = "${aws_instance.cilium-workshop-instance[each.value.instance].public_dns}"
    }
  }
}  
    
resource null_resource "make_sh_script_executable" {
  depends_on = [ aws_instance.cilium-workshop-instance ]
  for_each = toset(var.ec2_instances)

  provisioner "remote-exec" {
    inline = [
      "find ~/workshop -name '*.sh' -exec chmod +x {} \\;",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.private_key[each.key].private_key_openssh
      host        = "${aws_instance.cilium-workshop-instance[each.key].public_dns}"
    }
  }
}