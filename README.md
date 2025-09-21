# Text-to-speech-converter
Converting text to speech using AWS Polly in integration with Terraform for automating deployment 
Tech Stack :
IAM User
API Gateway
AWS Lambda
AWS Polly
Terraform and Python Scripts 

 2-3 minutes explanatin :
 1. Project Introduction (Goal)
"The project I worked on was building a Text-to-Speech converter using AWS Polly. The idea was to take text input from users through an API and convert it into natural-sounding speech. I chose to automate the entire infrastructure using Terraform, so that everything — from IAM roles to Lambda and API Gateway — gets deployed consistently in one command."

2. Step 1 – Configuring AWS CLI
"I started by configuring the AWS CLI with the credentials of an IAM user. This allowed Terraform to authenticate with AWS and create resources on my behalf. The IAM user basically had the necessary permissions to provision Lambda, API Gateway, and IAM roles."

3. Step 2 – Creating the IAM Role for Lambda
"Next, I wrote Terraform code to create an IAM role that my Lambda function would assume at runtime. This role had two key policies attached: the basic Lambda execution role for logging into CloudWatch, and Amazon Polly full access so that my Lambda could actually generate speech from text. This separation of roles is important — my IAM user deployed resources, but my Lambda function itself needed its own role to run securely."

4. Step 3 – Lambda Function Setup
"Then I deployed the core Lambda function. I wrote a Python script called handler.py that uses the Boto3 library to call Polly’s synthesize speech API. This script was packaged as a lambda.zip file, since AWS Lambda requires the code to be zipped before upload. In Terraform, I defined the Lambda with its runtime, handler, and linked it to the IAM role created earlier."

5. Step 4 – API Gateway Integration
"To make this accessible, I created an API Gateway using Terraform. I set it up with an HTTP endpoint, specifically a route POST /speak. I then integrated this API with my Lambda function using an AWS Proxy integration, so that whenever someone makes a POST request to the endpoint, it directly triggers my Lambda."

6. Step 5 – Permissions Between API Gateway and Lambda
"One important step was granting API Gateway permission to invoke my Lambda. By default, Lambda is private, so I had to use a Terraform resource called aws_lambda_permission. This explicitly allowed the API Gateway service to trigger my Lambda function, but only from my specific API instance. This ensures security and prevents unauthorized access."

7. End-to-End Flow
"So the flow works like this: a user sends text to the API Gateway endpoint → API Gateway invokes the Lambda function → the Lambda uses its role to call Polly and convert the text to audio → and the output can be returned as speech. Everything is fully automated with Terraform, so I can destroy or redeploy the entire stack at any time."

8. Why This Project is Valuable
"This project demonstrates how Infrastructure as Code simplifies cloud deployments, how different AWS services integrate together, and how IAM roles and permissions play different roles in deployment versus runtime. It also taught me about securing APIs, packaging Lambda functions, and managing resources consistently with Terraform."

9. Some screenshots
    <img width="1305" height="614" alt="image" src="https://github.com/user-attachments/assets/6594aa37-a6bc-4b08-abfe-6701066cce15" />
    <img width="1339" height="742" alt="image" src="https://github.com/user-attachments/assets/e2815794-f84e-47fb-ab95-ed619b12cda6" />
    <img width="1802" height="1194" alt="text-to-speech-Diagram" src="https://github.com/user-attachments/assets/14f44474-948d-41c6-a08b-55259fcfaedb" />

    
<img width="1106" height="581" alt="image" src="https://github.com/user-attachments/assets/9537c889-20ef-4923-8885-cfcb261eeeb9" />


