resource "aws_instance" "imported" {
    instance_type = "t3.micro"
    ami = "ami-09c813fb71547fc4f"
    tags = {
        "Name": "terraform-demo-changed",
        "Purpose": "terraform-practice"
    }
}