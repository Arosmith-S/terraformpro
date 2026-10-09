resource "aws_instance" "demo2" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  key_name      = "MyEC2 keypair"
  subnet_id = aws_subnet.public_subnet1.id
  
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = "true"

  tags = {
    Name ="projectins1"
    team = "sjce-devops1"
  }
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable --now docker
    usermod -aG docker ubuntu
    docker run -d --name test --restart always -p 8080:80 httpd:2.4
  EOF

}
resource "aws_instance" "demo3" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  key_name      = "MyEC2 keypair"
  subnet_id = aws_subnet.public_subnet2.id
  
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = "true"

  tags = {
    Name = "projectins2"
    team = "sjce-devops2"
  }
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable --now docker
    usermod -aG docker ubuntu
    docker run -d --name test --restart always -p 8080:80 httpd:2.4
  EOF
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.taskvpc.id

  tags = {
    Name = "learn_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "local_host" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
resource "aws_vpc_security_group_egress_rule" "alloutbound" {
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}
output "instance1_public_ip" {
  value = aws_instance.demo2.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.demo3.public_ip
}






