# Terraform AWS API Gateway resource module

This module simplifies the setup required to deploy Lambda functions under API Gateway. It also sets up CORS for created resources and methods.

It creates resources and sets up HTTP methods to invoke supplied Lambdas.

It allows set custom authentication to HTTP methods.

# Examples

## Complete example without authentication

```hcl
# /customer
module "customer" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${aws_api_gateway_rest_api.test_api.root_resource_id}"

  path_part = "customer"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "POST"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    }
  ]
}

# /customer/{customer-id}
module "customer_customer-id" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${module.customer.resource_id}"

  path_part = "{customer-id}"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "PUT"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "DELETE"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    }
  ]
}

# /customer/{customer-id}/orders
module "customer_customer-id_orders" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${module.customer_customer-id.resource_id}"

  path_part = "order"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "POST"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    }
  ]
}

# /customer/{customer-id}/orders/{order-id}
module "customer_customer-id_order_order-id" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${module.customer_customer-id_orders.resource_id}"

  path_part = "{order-id}"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "PUT"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    },
    {
      method = "DELETE"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
    }
  ]
}
```

## Example using Cognito authentication

```hcl
# /customer
module "customer" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${aws_api_gateway_rest_api.test_api.root_resource_id}"

  path_part = "customer"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}"
      credentials = "${aws_iam_role.api_gateway.arn}"
    },
    {
      method = "POST"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}"
      credentials = "${aws_iam_role.api_gateway.arn}"
    }
  ]
}

# /customer/{customer-id}
module "customer_customer-id" {
  source = "fernanfpinformatica/api-gateway-resource/aws"
  version = "X.X.X"

  api_id = "${aws_api_gateway_rest_api.test_api.id}"
  parent_resource_id = "${module.customer.resource_id}"

  path_part = "{customer-id}"

  methods = [
    {
      method = "GET"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}"
      credentials = "${aws_iam_role.api_gateway.arn}"
    },
    {
      method = "PUT"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}"
      credentials = "${aws_iam_role.api_gateway.arn}"
    },
    {
      method = "DELETE"
      invoke_arn = "${aws_lambda_function.crud_lambda.invoke_arn}"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "${aws_api_gateway_authorizer.test_api.id}"
      credentials = "${aws_iam_role.api_gateway.arn}"
    }
  ]
}
```
*Forked from https://github.com/mewa/terraform-aws-serverless-resource*
