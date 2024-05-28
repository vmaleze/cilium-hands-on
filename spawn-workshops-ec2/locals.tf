locals {
  generated_folder="${path.module}/../generated"
  ssh_generation_folder="${local.generated_folder}/machine-configs/"
  distribution_folder="${local.generated_folder}/distribution/"

  local_scripts_to_copy = flatten([
    for instance in var.ec2_instances: [
      for script in fileset("${path.module}/connection-scripts/", "**"): {
        key = "${instance}-${script}"
        content = file("${path.module}/connection-scripts/${script}")
        filename = "${local.ssh_generation_folder}/${instance}/${script}"
      }
    ]
  ])

    workspace_dirs_to_copy = flatten([
    for instance in var.ec2_instances: [
      for folder in var.folders_to_copy_in_workspace: {
        key = "${instance}-${folder}"
        folder = folder
        instance = instance
      }
    ]
  ])
}