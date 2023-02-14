# export DEFAULT_REGION={Your Default Region}

if [ $DEFAULT_REGION == "us-east-1" ]; then
    sudo rm -rf /usr/local/bin/aws
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi
docker build -t py3.9 .
docker run --name py3.9 py3.9:latest
docker cp py3.9:/temp/package ./
cd ./package
zip -r ../my-deployment-package.zip .
cd ../
zip -g my-deployment-package.zip lambda_function.py
aws configure set default.region $DEFAULT_REGION
aws lambda update-function-code --function-name $LAMBDA_FUNCTION_NAME --zip-file fileb://my-deployment-package.zip
