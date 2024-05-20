variable "ec2_instances" {
    type = list(string)
}
variable "common_prefix" {
    type = string
}

variable "folders_to_copy_in_workspace" {
    type = list(string)
}