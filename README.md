# LAMBDA TEST IN CI PIPELINE

How to test LAMBDA function in a CI pipeline? A simple solution using DGoss and CircleCI.


## Prerequisite

* Install [DGoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)

### CloudFormation Lambda sample definition

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
