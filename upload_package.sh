docker build -t py3.9 .
docker cp py3.9:/temp/package ./
zip -r my-deployment-package.zip ./package
zip -g my-deployment-package.zip lambda_function.py
aws configure set default.region $DEFAULT_REGION
ws lambda update-function-code --function-name webex_bot --zip-file fileb://my-deployment-package.zip