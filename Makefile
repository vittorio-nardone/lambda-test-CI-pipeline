## delete pycache, build files
clean:		
	@rm -rf build build.zip
	@rm -rf __pycache__

## create Docker image with requirements
docker-build:		
	docker build . -t lambda-test-ci-pipeline_lambda:latest

## run "src.lambda_function.lambda_handler" with docker-compose
## mapping "./tmp" and "./src" folders. 
## "event.json" file is load and provided to lambda function as event parameter  
lambda-run:			
	docker-compose run lambda src.lambda_function.lambda_handler '$(shell cat "test/test-event.json")'

## prepares build.zip archive for AWS Lambda deploy 
## remember to set in lambda definition:
##		 PYTHONPATH : "/var/task/src:/var/task/lib" 
## 		 Handler: src/lambda_function.lambda_handler
lambda-build: clean 
	mkdir build build/lib
	cp -r src build/.
	pip install -r requirements.txt -t build/lib/.
	cd build; zip -9qr build.zip .
	cp build/build.zip .
	rm -rf build

## run dgoss in edit mode
lambda-test-edit: 
	dgoss edit -e DOCKER_LAMBDA_STAY_OPEN=1 \
           -e PYTHONPATH=/var/task/src:/var/task/lib \
           -v $(CURDIR)/src/:/var/task/src/ \
           -v $(CURDIR)/tmp/:/tmp/ \
           -v $(CURDIR)/test/:/var/task/test/ \
           -p 9001:9001 \
           lambda-test-ci-pipeline_lambda:latest

## run dgoss tests
lambda-test-run: 
	dgoss run -e DOCKER_LAMBDA_STAY_OPEN=1 \
           -e PYTHONPATH=/var/task/src:/var/task/lib \
           -v $(CURDIR)/src/:/var/task/src/ \
           -v $(CURDIR)/tmp/:/tmp/ \
           -v $(CURDIR)/test/:/var/task/test/ \
           -p 9001:9001 \
           lambda-test-ci-pipeline_lambda:latest