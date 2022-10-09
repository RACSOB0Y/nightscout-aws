# The following resource can be created so you can manage the registration as-code if you so choose.
# Please note this resource has special constrains which are unique to it.
# Read about it here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
# Please uncomment the block if you'd like to adopt management of the registered domain via code. 
# resource "aws_route53domains_registered_domain" "nightscout_domain" {
#   domain_name = var.domain
# }

# We use a data source to retreive the Route 53 Zone used by the domain in question.
data "aws_route53_zone" "nightscout_domain_zone" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_zone" "nightscout_subdomain_zone" {
  name = "nightscout.wastehq.uk"

  tags = {
    Environment = "nightscout"
  }
}

resource "aws_route53_record" "nightscout-ns" {
  zone_id = data.aws_route53_zone.nightscout_domain_zone.id
  name    = "nightscout.wastehq.uk"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.nightscout_subdomain_zone.name_servers
}

