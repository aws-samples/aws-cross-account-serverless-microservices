## AWS Cross Account Serverless Microservices

This repo contains a sample application composed of a web application supported by two serverless microservices. The microservices will be owned by different product teams and deployed into different accounts using AWS CodePipeline, AWS CloudFormation and the Serverless Application Model (SAM). At runtime, the microservices will communicate using an event-driven architecture which requires asynchronous, cross-account communication via an Amazon Simple Notification Service (Amazon SNS) Topic. 

## License

This library is licensed under the Apache 2.0 License. 
