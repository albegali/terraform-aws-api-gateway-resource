# Terraform AWS API Gateway resource module

*Forked from https://github.com/mewa/terraform-aws-serverless-resource*

This module simplifies the setup required to deploy Lambda functions under API Gateway. It also sets up CORS for created resources and methods.

It creates resources and sets up HTTP methods to invoke supplied Lambdas.

It allows set custom authentication to HTTP methods.

# Examples

```hcl
# /test
module "test" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "1.2.0"

  api = "${aws_api_gateway_rest_api.test_api.id}"
  root_resource = "${aws_api_gateway_rest_api.test_api.root_resource_id}"

  api_key_required = true # false by default

  resource = "test"
  origin = "https://example.com"

  methods = [
    {
      method = "PUT"
      type = "AWS", # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = "${aws_lambda_function.test_put_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS", # Optionally override method authorization, defaults to "NONE"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}" # Optionally set method authorizer_id, defaults to ""
    },
    {
      method = "DELETE"
      invoke_arn = "${aws_lambda_function.test_delete_lambda.invoke_arn}"
    }
  ]
}
```
