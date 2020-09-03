# Cyclos Application

Deploy the Cyclos app with CI/CD in an existing EKS cluster.

## Deploy Stack

```bash
npm uninstall -g cdk
npm i -g aws-cdk@1.57.0 crpm@2.1.0 typescript
npm i

# Clone the infrastructure code
git clone https://github.com/mscribe/crpm-eks-app

# Change directory
cd crpm-eks-app

# Deploy the application CI/CD, which deploys the application
# Replace ? with the management role ARN used to deploy EKS
cdk deploy cicd --parameters CfnRoleArn=?
```

## Destroy Stack

```bash
# Destroy the CI/CD pipeline
cdk destroy cicd
```
