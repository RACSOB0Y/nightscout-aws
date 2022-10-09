# The following resource can be created so you can manage the registration as-code if you so choose.
# Please note this resource has special constrains which are unique to it.
# Read about it here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
# Please uncomment the block if you'd like to adopt management of the registered domain via code. 
# resource "aws_route53domains_registered_domain" "nightscout_domain" {
#   domain_name = var.domain
# }
# Hosted Zone for example.com
resource "aws_route53_zone" "zone_main" {
  name          = "wastehq.uk"
  comment       = "Hosted Zone for wastehq.uk"

  tags {
    Name      = "wastehq.uk"
    Origin    = "terraform"
    Workspace = "${terraform.workspace}"
  }
}

# Hosted Zone for dev.example.com
resource "aws_route53_zone" "zone_sub" {
  name          = "nightscout.wastehq.uk"
  comment       = "Hosted Zone for nightscout.wastehq.uk"

  tags {
    Name      = "nightscout.wastehq.uk"
    Origin    = "terraform"
    Workspace = "${terraform.workspace}"
  }
}

# Record in the example.com hosted zone that contains the name servers of the dev.example.com hosted zone.
resource "aws_route53_record" "ns_record_sub" {
  type    = "NS"
  zone_id = "${aws_route53_zone.zone_main.id}"
  name    = "nightscout"
  ttl     = "86400"
  records = ["${aws_route53_zone.zone_sub.name_servers}"]
}

