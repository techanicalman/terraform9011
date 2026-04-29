ec2_config = [ {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.micro"
} ,{
  ami = "ami-0f3caa1cf4417e51b"
  instance_type = "t2.micro"
}]


ec2_maap = {
  "ubuntu" = {
    ami = "ami-0b6c6ebed2801a5cb"
    instance_type = "t2.micro"
  },
  "amazon-linux" = {
    ami = "ami-0f3caa1cf4417e51b"
    instance_type = "t2.micro"
  }
}
