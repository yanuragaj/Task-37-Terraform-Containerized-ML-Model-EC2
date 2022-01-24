module "task37-EC2" {
    source="../Modules/EC2-Instance"  
}

module "task37-ALB" {
    source="../Modules/AWS_ALB"  
}
