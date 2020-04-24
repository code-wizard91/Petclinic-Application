# QACFinalProject

## Contents 
* [Introduction](#Introduction)  
* [Deployment Pretequisites](#prerequisites)
* [Planning](#planning)
* [Use Cases](#UserCases)
* [Risk Analysis](#Risk) 
* [Technologies Used](#Technology) 
* [Environments ](#Environments)
* [Testing](#Testing)
* [Deployment Pipeline](#pipeline)
* [Deployment](#Deployment)
* [Costs](#Costs) 
* [Project Conclusion](#Conclusion) 
* [Future Work](#FutureWork) 


<a name="Introduction"></a>
## Introduction 
### Project Brief
The general outline of this project was to use all the concepts from previous training modules to plan, design and implement a solution for automating the deployments and development workflows for the projects that are linked below: 
 
**Frontend client using AngularJS** https://github.com/spring-petclinic/spring-petclinic-angular
 
 **API using Java** https://github.com/spring-petclinic/spring-petclinic-rest
 
As a group of 4 individuals we would have to either use the tools we had been taught during our training such as **Terraform, Kubernetes, Ansible** or utilise other tools that would work in a similar fashion to these justifying why they would be the most preferable for deployment. 

The deployment of this project would require automated building and re-deployment to testing and live environments upon any GitHub changes, whilst also keeping track of running costs.   

<a name="prerequisites"></a>
## Deployment Prerequisites
A unix-machine with Terraform and Ansible installed along with subscription to a cloud provider. In this case the cloud provider used is Azure, but this can be configured with any.

### Terraform
Terraform needs to be configured with a provider to manage resources. In this case a service principal is set up, allowing Terraform to connect to our Azure subscription with a clientID and clientSecret.

### Ansible
A Unix based system is required in order to run ansible (we used Ubuntu 18.04 LTS), and configure the virtual machines created by Terraform.

<a name="planning"></a>
## Planning

As this is a group project composed of 4 members, there will need to be adequate planning measures in place so that all individuals can work efficiently and coherently towards the main goal which is the successful deployment of the application.  

Therefore, throughout the duration of this project we chose to employ **Scrum** as our project management framework. Unlike conventional methods of project planning, Scrum promotes and encourages teams to learn through experiences, self-organise and share ideas whilst working towards resolving a problem.

This short video further explains the benifits of using **SCRUM**
[![Scrum Link](https://github.com/zReginaldo/MySQLdb/blob/master/Document/youtube-logo-png-46031.png)](https://www.youtube.com/watch?v=2Vt7Ik8Ublw) 

### Group member roles: 

### Product owner 
Our Trainer Jay Grindrod 

### Team members
https://github.com/AlinaDenisaB

https://github.com/Ezzmo

https://github.com/code-wizard91

### Scrum Master 
 https://github.com/zReginaldo

Below shows the inital Scrum plan for this project, this was agreed apon by each group member and includes the start and finish dates of each of sprint. 

![Planning](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/Scrum%20Sprints.PNG)

Throughout the course of the project we also had daily standups where we would inform eachother what we had been done, review what was left to do and make a suitable plan of action for that day, filling in the tasks we had discussed under each sprint as well as assigining the task to invdividuals.

![Planning](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/Trello-Like-Planning.PNG)

<a name="UserCases"></a>
## User Cases
![UserCases](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/UserStories.PNG)

<a name="Risk"></a>
## Risk Analysis
![RiskAssessment](https://github.com/Ezzmo/Petclinic/blob/develop/Documentation/RiskAssessment.PNG)


<a name="Technology"></a>
## Technologies Used
![TechnologiesUsed](https://github.com/Ezzmo/Petclinic/blob/develop/Documentation/TechnologiesUsed.png)

<a name="Environments"></a>
## Environments
In this project we used multiple environments and tools to test build and deploy the applications, the tools are listed below:

- Terraform

Terraform was used to create our deployment infrastructure as code, in this case to create two environements; Staging and Production. In Terrafform each environment is identical but is tagged as Production and Staging. The environments have 1 Kubernetes Cluster and all it dependencies, 1 VM for controlling the clusters using Kubectl and testing the app and finally a Jenkins CI/CD server which executes the pipeline by building, testing and deploying the application on the K8 cluster.

We chose Terraform as it lets you write infrastructure as code, the infrastructure configurations can be versioned and maintained, so if another environment needs to be created, you can be sure that you are using the latest configurations which avoids environment drift.

 ***** Setup files can be found in the Terraform Folder *****

- Ansible

Ansible was used to provision and configure the dependencies required to test and build our application on our remote hosts, this was done so that our app could be deployed seamlessly after Terrafform creates the infrastructure that we need. We created multiple custom roles inside Ansible that; install Docker, Install the applications our app needs to work, configure Jenkins and more.

We chose Ansible for this project as it is a very useful automation tool that lets you configure manage and deploy applications, also can configure Windows machines as well as Linux machines, YAML is easy to read and understand and gives you a clear view of what is happening, Ansible is also agentless and doesn’t need any extra configuration and comes with all the features ready to use out the box.


***** Setup files can be found in the following dir -> terraform/ansible

- Kubernetes

Our Kubernetes cluster was created using Terraform and this was done in the testing and production environments. Kubernetes helped us deploy our application containers and was used because it is easily able to manage, scale and deploy large applications. It is also very easy to use with Azure and other cloud providers. 

***** Setup files can be found in the following dir -> terraform/kubernetes-cluster

<a name="Testing"></a>
## Testing

Testing was conducted using a combination of **Karama, Jasmine, Angular, NodeJs and Maven** the testing files and location had already been configured for the application so our only responsibility was to initate the tests. Testing was a tedius process for us during this project as we had not dealt with any of the technology before, however this just meant we had to allocate additional time to learning and understanding this new technology. 

### Frontend Testing
Testing was conducted simply by using the command ```ng test``` this would run the tests that were pre defined and show us how many had passed or failed. However tests were displayed using the browser **CHROME**, requring us to open a new weeb page and run a dubg to recieve the full list of tests. In order for tests to be applicable for Jenkins we had to slighlt tweak the configuration files. 

**Changes Made**
```
Install >>> npm install phantomjs

plugins >>> require('karma-phantomjs-launcher'), require('karma-coverage')

browsers: ['Chrome'] >>> ['PhantomJS']

Coverage In Terminal >>> coverageReporter:{ type:'text'}, 

reporters : ['progress', 'kjhtml'] >>> ['progress', 'kjhtml','coverage']

```
After this was done we were able to get the results of the tests printed in the terminal as well as the coverage report for all of the tests that were conducted. When wanting to conduct the tests in Jenkins you will also need to change the **Karma.conf.js** file so that the terminal dosent hang by changing ```singleRun: false >>> true```  [Test Coverage In Terminal](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/TerminalTesting.PNG)

![Testing](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/Testing.PNG)

### Backend Testing
Tesing the backend was relativly simple, all that was required was to install **Maven** and run the simple command ```mvn test``` this would go through all of the test files and output weather or not the tests had passed or failed. 

![Testing](https://github.com/Ezzmo/Petclinic/blob/master/Documentation/Testing_Backend.PNG)


<a name="pipeline"></a>
## Deployment Pipeline
![s5](/Documentation/Pipeline.jpg)

<a name="Deployment"></a>
## Deployment

We used Terraform to create the infrastructure (VM's and Kubernetes Cluster) after this process we used Ansible to go into the VM's we  created and install all the applications we would need for the project to work e.g Jenkins, Java, Python, Docker, Maven. After running Ansible we then trigger the build process which is running on our Jenkins CI/CD server, this tests the application and if the tests pass the deployment stage is triggered and the application is deployed to the Kubernetes Cluster on Azure. See video Below for more info.

[![pipeline_video](/Documentation/video.jpg)](https://youtu.be/jcAL9zQ6r8Q)


<a name="Costs"></a>
## Costs
We used Pricing Calculator to configure and estimate the monthly running costs for the Azure products that we need to automate the deployment of the application. We decided that we need 2 VMs and the Azure Kubernetes Service, we used East US as region because that’s what we found available according to the subscription that we were using and we came to the conclusion that we would have an operational expenditure of £160.17, paying only for what we are using with no upfront costs for the services.
![Costs](https://github.com/Ezzmo/Petclinic/blob/develop/Documentation/Costs.PNG)


<a name="Conclusion"></a>
## Project Conclusion
* We are happy with what we managed to accomplish in such a short time, even at the beginning it was quite difficult to understand the application, considering that the backend use Java and the frontend use AngularJS, which we weren’t familiar with. We faced problems, like not being able to link the backend and the frontend while applying Kubernetes or having issues while testing the application, but we supported each other as a team, we didn’t give up until we managed to do everything we planned and we also had Jay pointing us to the right direction.

<a name="FutureWork"></a>
## Future Work
* What we could do more is having a more specified cost analysis, or even adding graphics to the final presentation. 
