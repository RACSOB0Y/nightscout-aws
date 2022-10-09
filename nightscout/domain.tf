# The following resource can be created so you can manage the registration as-code if you so choose.
# Please note this resource has special constrains which are unique to it.
# Read about it here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
# Please uncomment the block if you'd like to adopt management of the registered domain via code. 
# resource "aws_route53domains_registered_domain" "nightscout_domain" {
#   domain_name = var.domain
# }
data "aws_route53_zone" "nightscout_domain_zone" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "nightscout_domain_record" {
  zone_id = data.aws_route53_zone.nightscout_domain_zone.id
  name    = var.domain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.nightscout.public_ip]
}
