1. Migrate a exisiting infrastructure to terraform

use terraform import

    Step 1 : main.tf (import block)

            import {
                id = "i-1839929010011" instance id

                to = aws_instance.example
            }
    
    Step 2 : terraform init
    Step 3 : terraform plan -generate-config-out = generated.tf(generate a new file with all the resource imported)
    Step 4 : terraform import aws_instance.example i-1233849929(state file will be created)
    Step 5 : terraform plan 

2. Drift detection

    A . set up a corn Job for every 1 day - detect the Drift
    terraform refresh - will refresh the state file..there is change in the remote object
    will update the state file.

    B. we can create a lambda fun - if any change made my iam user -
    we will check for the audit logs - send out email

3. You have multiple environments - dev, stage, prod for your application and you want to use the same code for all of these environment. 
How can you do that?

    * terraform modules - re-use the configuaration for various environment by passing in
    different parameters.
    * terraform workkspace - using the same code we have with different state file for different environment
    * terraform workspace create - create the workspace
    * terraform workspace select - switch to the workspace

4. What is the Terraform state file, and why is it important?
    Terraform state file is a Json or binary file that stores the current state of the managed infrastructure.
    it is a blue-print that stores the information abt infrastructure that u manage.
    it's cruical because it helps terraform to understand wht's already setup
    and wht change need to made. by comparing the desired set with current set..terraform can accurate update the infrastructure


5. Jr DevOps Engineer accidently deleted the state file, what steps should we take to resolve this?

    1. manually reconstruct the state by inspecting existing infrastructure and using `terraform import` for missing resources.
    2. I will store my state file in s3 bucket(remote backend)

6. What are some best practices to manage terraform state file?

    - Remote backend -> store the state file remotely for safety colaboraiton and version lock
    - state locking -> enable state locking to prevent conflicts in concurrent operation.i use dynamodb for stateLocking
    - Access Controls: Limit access to the state file to authorized users and services.
    - Environment Separation: Maintain separate state files for each environment or utilize Terraform workspaces to manage multiple state files.

7. Your team is adopting a multicloud strategy and you need to manage resources on both AWS and Azure using terraform so how do you structure your terraform code to handle this?
    - Set up provider configurations for both AWS and Azure in separate blocks.
    - Create Terraform code with separate modules for AWS and Azure resources.

8. There are some bash scripts that you want to run after creating your resources with terraform so how would you achieve this
    provisioners will user 
    local-exec - in your local machine
    remote-exec - in you remote machine
    You can execute scripts using the local-exec and remote-exec provisioners.

9. You have a RDS Database and EC2 instance. EC2 should be created before RDS, How can you specify dependencies between resources in Terraform?
    Answer : depends_on 
     By including this attribute, you define an explicit ordering of resource creation and ensure that one resource is created before another.

10. You have 20 servers created through Terraform but you want to delete one of them. Is it possible to destroy a single resource out of multiple resources using Terraform?
        ```bash
    terraform destroy -target=aws_instance.my_instance
        ```

11. What are the advantages of using Terraform's "count" feature over resource duplication?
    
* count will define how many resource u want to create.
* create resource based on the count count = var.ec1_instance ? 1:0
      
12 What is Terraform's "module registry," and how can you leverage it?
    Terraform's "module registry" is a central repository for sharing and discovering Terraform modules. The module registry allows users to publish their modules, which are reusable and shareable components of Terraform configurations.

    By leveraging the module registry, you can easily discover existing modules that address your infrastructure needs, reducing duplication of effort. You can reference modules in your Terraform code using their registry URL and version.

13. How can you implement automated testing for Terraform code?
    - terraform validate or terraform format
    Tools :
        * Unit testing : validate individual modules with terraform-compliance or terratest.
        * integarating testing : use terratest or kitchen-terraform for real/simulated environment test.
        * linting : ensure code quality with tflint or checkov.
        * static analysis : detect security issues using tfec.
        * CI integration - Jenkins, gitlab
        * mocking: simulate dependencies mockery or terraform mocking .
        * environment management : manage environment with terraform workspaces.
    

14. You are taskeds with migrating your existing infrastructure from terraform version 1.7 to version 1.8 so what kind of considerations and steps would you take?
    When upgrading Terraform versions:

- **Review the upgrade guide** to understand changes, deprecations, and new features.
- Update configuration files to match new syntax and handle deprecated features.
- Address any breaking changes introduced in the new Terraform version.
- Ensure thorough testing in a non-production environment before applying changes in production.
- Document any changes and provide training to team members as needed.

Ensure you meet the minimum requirements, update your CI/CD pipelines, and backup your state files before starting the migration proce


15. Your company is looking ways to enable HA. How can you perform blue-green deployments using Terraform?
    * create a new environment along side with the exisiting one
    * test everything working fine..
    * switch the load balancer to new environment

16. Your company wants to automate Terraform through CICD pipelines. How can you integrate Terraform with CI/CD pipelines?

    * push the  gitlab CICD pipelines
    * init - check the configuaration valid
    * validate - check the configuaration valid
    * plan - check the configuaration valid
    * apply - manually
    * delete - manually

17. Describe how you can use Terraform with infrastructure deployment tools like Ansible or Chef.

        * terraform is a infrastructure as code tool it will used to create a infrastructure like ec2,s3.
        * Ansible or chef is a configuaration management tool can handle task such as installing software, configuring servers and manging services

        by combaning, we can achieve a comprehensive infrastructure automation solution.

18. Your infrastructure contains database passwords and other sensitive information. How can you manage secrets and sensitive data in Terraform?

        * store secrets outside version control files, use hashicorp vault.
        * attribure called sensitive
        * never-hardcore passwords
        * utilize terraform input variable or environment variable to pass sensitive
        values secretly in runtime

20. Suppose you created an ec2 instance with terraform and after creation, you have removed the entry from the state file now, when you run terraform apply what will happen?

    As we have removed the entry from that state file so terraform will no longer manage that resource so on the next apply it will create a new resource.

20 . What is a plugin in Terraform?
    The plugin is responsible for converting the HCL code into API calls and sends the request to the appropriate provider (AWS, GCP)

21.  What is a null resource?

As in the name you see a prefix null which means this resource will not exist on your Cloud Infrastructure.
    Run shell command
    You can use it along with local provisioner and remote provisioner
    It can also be used with Terraform Module, Terraform count, Terraform Data source, Local variables
    It can even be used for output block

22. What is the difference between locals & variables in terraform?

    The variables are defined in the variables.tf file or using variables keyword that can be overridden but the locals can not be overridden.
    So if you want to restrict the overriding the variables at that time you need to use the locals.

23. Let’s say you have created an EC2 instance using Terraform and someone does the manual change on it next time you run Terraform plan what will happen?

Terraform state will be mismatched and terraform will modify the EC2 instance to the desired state 
i.e. whatever we have defined in the .tf file

24. How can we rename a resource in Terraform without deleting it?

    We can rename a resource without deleting it using terraform mv command

25. : How I can delete/destroy specific resources without changing logic?

    Using taint and destroy command
    We need to taint that resource using terraform taint RESOURCE_TYPE.RESOURCE_NAME command
    After tainting the resource, you can run the “destroy” command to remove the tainted resources using terraform destroy -target=RESOURCE_TYPE.RESOURCE_NAME command


26. terraform module
        We can create the terraform modules one time and reuse them whenever needed
    To make to code standardized
    To reduce the code duplication

27. Why Should You Use Version Control with Terraform?

    Version control helps track changes to your Terraform configurations, allowing you to roll back to previous versions if necessary. 
    Use Git repositories to manage your .tf files and follow a branch strategy to handle updates.

28. You are working with multiple environments (e.g., dev, prod) and want to avoid duplicating code. How would you structure your Terraform configurations to achieve code reuse?
    * We make use of modules so that we can avoid duplication of code.
    * Terraform workkspace

    terraform workspace list #To list all workpace 

    terraform workspace new dev 
    terraform workspace new prod

    #Switching Between Workspaces 

    terraform workspace select <workspace_name> 

29. Describe a situation where you might need to use the terraform remote backend, and what advantages does it offer in state management?
        The terraform remote backend allows you to store Terraform state files in a centralized location,
         such as an object storage service like Amazon 

30. Explain a situation where you might need to use terraform taint and what effect it has on resources.
    Terraform’s taint the command is used to mark a resource for recreation during the next terraform apply.
    This is particularly useful in situations where you want to force the recreation of a resource due to configuration changes, updates, or issues encountered during provisioning.

31. You are managing a large Terraform state file, and you notice performance issues and longer execution times during terraform plan and terraform apply. How would you optimize this setup?

* store the state file in s3 bucket
* split the statefile based on the modules in s3 bucket(State File Partitioning)

32. How would you handle and prevent drift in your infrastructure with Terraform, especially if changes are made outside of Terraform (e.g., manual changes in the AWS console)?

* setup cornJob in cicd pipeline to check the drift, like corn job for dailyy to detect the drift
* use terraform plan to check any changes happend in the infrastructure comparing with state file, if changes happend send out email
* use terraform refresh

33. You are tasked with managing a multi-region infrastructure using Terraform. How would you structure your configuration to ensure resources are deployed consistently across multiple regions?

* we can use modular-approach
* we can use alias to specify the instance in which region it needs to be created

34. You are managing a Terraform codebase for a multi-environment setup (dev, staging, and prod). A recent change in the dev environment caused an issue in the staging environment. How would you design a strategy to manage Terraform code changes to prevent such issues in the future?

* use terraform workspace, create a statefile for each environment
* store it in remote backend s3 bucket and state locking using dynamodb
* use modular approach to re-use the code for multi environment
* either u can create a differnet tfvars file or u can use condition to pass the arguments
