resource "aws_key_pair" "eks" {
  key_name   = "expense-eks"
  public_key = "ssh-rsa MIIEowIBAAKCAQEAoyZTtgOsGpa+f+qWzrFMqGBgtYdx5Di7PZYlFmSTruMM35ne
De+ahrEWXCWAPOgbnWwhOi+pt7Z1Z2lUigoMk7IDAgyB1Wq6LwsdR/2xqtD4nxGe
S1rGlwMcn0Oroi+C0t6pL8kF5ySMKfpC3kWurn/F89BgnjkNfopbtWqxOXiEAdM6
0QsPb1tBTyccNAYyJoFNx9wKJlJMLCI8i57fD6K90spyx8FizOAKF346eCZzZZ/Y
T56o26TppfAg+eYKVY2crdvZqXzJM552xSo77i/21/ac00D7+5fjENT8qlKRWEQ6
hNs1vyuiV6pDlyQ5g8FBCA7A2jly0hcW+h0eSQIDAQABAoIBADYh9GqTI1qbI9Ar
lSg1mdrQR6ZTr41q6W2Q0PNyIbJIcbALTKtREfOY9HNUmg0bcnY0N34n7GchaikK
wNsgZHXo/aiDX9zhEa+kP23wli+4MJYO8XfNQdE/XhLWEC+7FexDpt1NFOFRthQD
joZTlpcdnB++xyAYjAqte6phITaQ55MiA5jC8hFwzT342+lRHOtv8KFT0g7h3ONR
RwelTvSFRd7gcVtOQrnregRi/ENOFijFGQpIRvw0urpiagKfzlzYyctRqjO9vekl
cgPSkBrNoY0OqNi0vc+kRLNUpWVfj6s235tvu1THs4BfKS0J27fmKNybdL15iIum
eMYfmoUCgYEAzq7+CeEflTsgAbVK1T8fdGaT5+rWqN+xSUP6RUlzHSCPl9/mEF3S
ejoN9Rvkb3YJxR3vOW7XWmMFgfVMSTwdU9/EG1jxw0wTLiTYvgqf0wC/LRKhWALj
g/eMrXbQaC8pFihKd1wDdxhMMLcbo2paGEPv7iwNkp0aM5kzm9XAOAsCgYEAyhQf
sViS5pF8SQWdq7HRy2lXAtbJsvKMY1kCKMOb7wabIalnCVTyYY+Im8iBtb48068Z
b7AnLmV1uuMexRe+CPHP4Ob2blCattfG/bzgbEdINwCzcNQFAHJOndTFn0bMCjHL
RgjLC2qYeVZnc3ihMto+QqmpCI4Fi/GLi3nIM3sCgYEAwZiCViir17GxEkiJVuOw
h+yJgEOlXDtjqZfl9j6Nd+wG9KCBtDTdsSVt63h76besARo/+REM4Ro9j3SAR1zq
r6S64U7X7jH1CVT0PFZhTFi3ufVocbMK/5LCD71qCxyZpKqKzfC/Qi/dNghd+Bzn
VTFVrUdQU1Oatlg7Ui3Oxe8CgYBRF1A8f5m7kqg4OVuzOZFBukzjY8Pe3nw9pcs7
Bnv9qD36fRtO4Fq/kbS1Jvn+L5ADNmHTsvGWKbrbuyZu2v80Ya0UyDodvJTJSL+e
tPuuF9C/2bUoUryLGFO5/FctemCIusCiowav1x/GmUi8Sq0NVgzj/WdKeot5Q/3G
g6E2HwKBgHhWdy6R0oww6eKsO0Gs+UniL6LzOA0SQM4tCRqXWW7Ctz6CKTF3WMYS
T+7Qz1UVZTBBl4Iy2GJPawe2ws6cMSnlWlsMpJKSDB8uB3RTKKp+R+ro6MPivcd4
sIE/NwReBRZm3rv25dKWAoynydikc0Efc1K2/Z+2AIth2HC/yXUO devops"

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project}-${var.environment}"
  cluster_version = "1.31" # later we upgrade 1.32
  create_node_security_group = false
  create_cluster_security_group = false
  cluster_security_group_id = local.eks_sg_id
  node_security_group_id = local.node_sg_id

  #bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    metrics-server = {}
  }

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["m5.xlarge"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    }
  }

  tags = {
        Name = "${var.project}-${var.environment}-bastion"

    }
  
}