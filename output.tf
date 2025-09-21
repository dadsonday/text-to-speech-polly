// This file is required to display the result or the output after main.tf runs .
// it will display the name of lambda function and the arn it is using

output "function_name" {
  value = aws_lambda_function.text_to_speech.function_name // will display function name
}
output "function_arn" {
    value = aws_lambda_function.text_to_speech.arn // will display arn used
}
output "api_endpoint" {
  description = "Base URL of the API Gateway HTTP endpoint"
  value = aws_apigatewayv2_api.create_api.api_endpoint
}
//output.tf should not be need to run manually. when you write "terraform.apply" output.tf will be run too 
// on writing "terraform.apply", every tf file runs. 