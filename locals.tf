locals {
  private_base_cidr = cidrsubnet(var.base_cidr, 1, 0) # 10.32.0.0/17
  public_base_cidr  = cidrsubnet(var.base_cidr, 1, 1) # 10.32.128.0/17
}