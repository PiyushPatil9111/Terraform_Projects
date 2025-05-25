resource "aws_instance" "nat" {
  ami                         = "ami-0c02fb55956c7d316" #
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id # Launching in the first public subnet
  associate_public_ip_address = true
  source_dest_check           = false                   # Allows instance to forward traffic (NAT behavior)

  vpc_security_group_ids = [aws_security_group.nat_instance_sg.id]

  tags = {
    Name = "nat-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Enable IP forwarding by adding 1 to the ip forward file
              echo 1 > /proc/sys/net/ipv4/ip_forward
              
              # Configure NAT with iptables: masquerade outbound traffic through eth0
              iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF
}

