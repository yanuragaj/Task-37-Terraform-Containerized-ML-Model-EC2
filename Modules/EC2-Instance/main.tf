provider "aws"{
    region = "ap-south-1"
    profile = "default"
    }

resource "aws_security_group" "allow_http_80_port"{
    name = "allow_http_80_port"
    description = "ALLOW HTTP 80 PORT"
    ingress{
        description = "Inbound rule"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
       ingress{
        description = "Inbound rule"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_http_80_port"
    }

    egress {
      cidr_blocks = ["0.0.0.0/0"]
      description = "OUTBOUND RULE"
      from_port = 0
      protocol = "all"
      to_port = 0
    } 

}


resource "aws_instance" "task_37"{
    ami = "ami-0af25d0df86db00c1"
    instance_type = "t2.micro"
    security_groups = ["allow_http_80_port"]
    key_name = "AWS-KEY"
      tags ={
        Name = "task-37"
    }
}


resource "aws_ebs_volume" "st1"{
    availability_zone = aws_instance.task_37.availability_zone
    size=10
    tags={
        Name="WEB SERVER HDD BY TF"
    }
}

resource "aws_volume_attachment" "ebs_attache"{
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.st1.id
    instance_id = aws_instance.task_37.id
}

resource "null_resource" "nullresource0" {
    connection {
  type = "ssh"
  user = "ec2-user"
  private_key= file("AWS-KEY.pem")
  host = aws_instance.task_37.public_ip
}

provisioner "remote-exec" {
    inline = [
        "sudo yum install docker -y",
        "sudo systemctl start docker",
        "sudo systemctl enable docker",
        "sudo docker run  -p 80:80 -d yanuragaj/dietpred:v3"
    ]
} 


}