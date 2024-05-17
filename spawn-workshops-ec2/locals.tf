locals {
  ssh_generation_folder="${path.module}/../machine-configs/"

  scripts_to_copy = flatten([
    for instance in var.ec2_instances: [
      for script in fileset("${path.module}/scripts/", "*"): {
        key = "${instance}-${script}"
        content = file("${path.module}/scripts/${script}")
        filename = "${local.ssh_generation_folder}/${instance}/${script}"
      }
    ]
  ])
}