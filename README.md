# LAMBDA TEST IN CI PIPELINE

[![CI](https://travis-ci.com/vittorio-nardone/lambda-test-CI-pipeline.svg?branch=master)](https://travis-ci.com/vittorio-nardone/lambda-test-CI-pipeline)

How to test LAMBDA function in a CI pipeline? A simple solution using [Goss](https://goss.rocks) and [TravisCI](https://travis-ci.com/).

## Prerequisite

* Install [DGoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss) to test your lambda code locally.

## Dummy source code
Lambda source code is in `src/lambda_function.py`. It's a sample function, performing math and using external packages (Pillow).
Response of lambda is tested by Goss script. `test/test-event.json` is a sample AWS SQS invocation event. 

## Commands

`make docker-build` to build docker image locally

`lambda-run` to run your lambda function locally during development

`lambda-test-run` to run lambda tests with Goss

## CI Pipeline

TravisCI is used to build docker image and perform tests at every commit. 
Please check `.travis.yml` file. 

## CloudFormation 

This is a sample CloudFormation definition.

```
    SampleFunction:
        Type: AWS::Lambda::Function
        Properties:
            Runtime: python3.7
            Description: This is an amazing function
            Handler: src/lambda_function.lambda_handler
            Role: 
                Fn::GetAtt: [ "SampleFunctionRole", "Arn" ]
            Environment:
                Variables:
                    PYTHONPATH: "/var/task/src:/var/task/lib"
            Timeout: 20
            MemorySize: 512
            Code:
                S3Bucket: 
                    Ref: SourceBucket
                S3Key: 
                    Fn::Sub: '${SourceBucketFolder}/SampleFunction.zip'
```
