# expense EC2 Module

**Inputs:**
* ami_id(Optional): String value. Default values is devops-practice AMI ID
* sg_id(Mandatory): User must supply sg_id
* instance_type(Optional): t3.micro is default value. User can provide t3.small or t3.medium
* tags(Optional): Default is empty. User can provide tags in map structure.

**Outputs:**
* public_ip: public IP of the instance created
* private_ip: private IP of the instance created