# resource
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${var.api_id}"
  parent_id   = "${var.parent_resource_id}"
  path_part   = "${var.resource_name}"
}

# resource methods
resource "aws_api_gateway_method" "method" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  authorization = "${lookup(var.methods[count.index], "authorization", "NONE")}"
  authorizer_id = "${lookup(var.methods[count.index], "authorizer_id", "")}"

  api_key_required = "${var.api_key_required}"

  count = "${var.num_methods}"
  http_method = "${lookup(var.methods[count.index], "method")}"
}

resource "aws_api_gateway_method_response" "method_response" {
  depends_on = [
    "aws_api_gateway_method.method"
  ]

  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"

  count = "${var.num_methods}"
  http_method = "${lookup(var.methods[count.index], "method")}"

  status_code = "200"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  depends_on = [
    "aws_api_gateway_method_response.method_response"
  ]

  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"

  count = "${var.num_methods}"
  http_method = "${lookup(var.methods[count.index], "method")}"

  status_code = "200"
}

# resource lambdas
resource "aws_api_gateway_integration" "resource_lambda_integration" {
  depends_on = [
    "aws_api_gateway_method.method"
  ]

  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"

  count = "${var.num_methods}"
  http_method = "${lookup(var.methods[count.index], "method")}"

  integration_http_method = "POST"
  type                    = "${lookup(var.methods[count.index], "type", "AWS_PROXY")}"
  uri                     = "${lookup(var.methods[count.index], "invoke_arn")}"
}

data "template_file" "method" {
  count = "${var.num_methods}"
  template = "$${method}"

  vars {
    method = "${lookup(var.methods[count.index], "method")}"
  }
}

module "resource_cors" {
  source  = "mewa/apigateway-cors/aws"
  version = "1.0.0"

  api = "${var.api_id}"
  resource = "${aws_api_gateway_resource.resource.id}"

  methods = "${data.template_file.method.*.rendered}"

  origin = "${var.origin}"
}
