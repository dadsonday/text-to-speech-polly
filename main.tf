// hii im writing this because I'll be creating a terraform script to deploy aws polly .
// hi i'm starting the project 
//firstly i started with configuring aws cli by installing it and giving credentials of iam user ie access key, password, region and output format of the code for reading 
// now I'm writing terraform main script that is used for invoking polly through lambda.
//this script will automatically deploy lambda.

provider "aws" {
                region = "us-east-1"
}
// now I'll make 3 resources using terraform to deploy aws resources 

// RESOURCE:1 - creating an iam role called lambda_role so that lamda can be run in the next steps 
// only lamda is allowed to access this iam role

resource "aws_iam_role" "lambda_role" { 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
//RESOURCE: 2 : Attaching basic execution policies for lambda
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
// RESOURCE for adding access to polly
resource "aws_iam_role_policy_attachment" "polly_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}
//RESOURCE 3 : Actuall calling lambda to run the main logic which is handler.py
resource "aws_lambda_function" "text_to_speech" {
  filename         = "lambda.zip" // zipped file . Zipping file is neessary as during deployment , unzipped folders arent accepted.
  function_name    = "textToSpeechLambda" //name of lamda function that will appear in aws console
  role             = aws_iam_role.lambda_role.arn //which iam role to activate is decided by the arn of that role
  handler          = "handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("lambda.zip") 
}
//RESOURCE 4 : this is used for creating an api that will accept http responses
resource "aws_apigatewayv2_api" "create_api" {
    name = "text_to_speech_api"
    protocol_type = "HTTP"  
      cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["Content-Type"]
  }
}
//RESOURCE 5 : integrtion of apigateway with lambda
resource "aws_apigatewayv2_integration" "api_integration" {
  api_id = aws_apigatewayv2_api.create_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.text_to_speech.invoke_arn
  payload_format_version = "2.0"
  
}
//RESOURCE 6: Creating a route for http method i.e a route to connect to lambda when we get post 
resource "aws_apigatewayv2_route" "api_routing" {
  api_id = aws_apigatewayv2_api.create_api.id
  route_key = "POST /speak"
  target = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}
//RESOURCE 6 : deploying the api to production ie sending user's request through api post to lambda
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.create_api.id
  name ="prod"
  auto_deploy = true
  
}
// RESOURCE 7 : Allowing api to call lambda so that lambda can later access polly (which is done by iam)
resource "aws_lambda_permission" "allow_apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_to_speech.function_name
  principal = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.create_api.execution_arn}/*/*"
}
//done
// when you write terraform apply, the main funcrion will create an iam role that would be interpreted by lambda 
// then it will see the policies lambda is subjected to like basic execution policy
//then it will run the text to speech function using lambda, where it it connects to the lambda.tf file which contain handler.py + the dependencies to run it
// when you go to aws console and look at lambda service it will have lambda.zip file which has handler.py + dependency required to run lambda function.