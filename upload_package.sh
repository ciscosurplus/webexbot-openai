# export DEFAULT_REGION={Your Default Region}
# export LAMBDA_FUNCTION_NAME={ Lambda Function name }

export IMAGE_NAME=`openssl rand -hex 4`
export CONTAINER_NAME=`openssl rand -hex 4`
docker build -t $IMAGE_NAME:py3.9 .
docker run --name $CONTAINER_NAME $IMAGE_NAME:py3.9
docker cp $CONTAINER_NAME:/temp/package ./
docker rm $CONTAINER_NAME
cd ./package
zip -r ../my-deployment-package.zip .
cd ../
zip -g my-deployment-package.zip lambda_function.py
aws configure set default.region $DEFAULT_REGION
aws lambda update-function-code --function-name $LAMBDA_FUNCTION_NAME --zip-file fileb://my-deployment-package.zip
