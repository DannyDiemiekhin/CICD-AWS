output "public_ipv4_address" {
    value = aws_instance.my-web.public_ip
  
}