# The .tfvars file can be used to set default values but those variables can only be used at the child module level if defined
# The .tf variables file can be used to DECLARE variables that will exist in the configuration at this particular module level.
# Without the .tf module at the correct level, your main.tf file will not be able to reference the relevant variables

variable "region" {
    type = map(string)
    description = "Region names for AWS"
    # Note: Adding a `default` argument reassigns the variable declared in the .tfvars root module. eg:
    # default = {}
}

variable "amis" {
    type = map(string)
    description = "Default free tier AMIs for each AWS region"
}

output "ip" {
    value = aws_eip.tf_elastic_ip.public_ip
}