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
# Replace the first ? with the management role ARN used to
# deploy EKS and the second ? with the EKS cluster name
cdk deploy cicd \
    --parameters EksRoleArn=arn:aws:iam::774461968944:role/eks-role-us-east-1 \
    --parameters ClusterName=eks-cluster
```

## Configure EKS Role for CodeBuild

CodeBuild will need to assume the existing EKS role in order to deploy the application.  So, you will
need to edit the trust relationship so the CodeBuild ARN is allowed to assume the EKS role.

1.  In the AWS Console, navigate to IAM -> Roles.
2.  Search for the existing EKS role that was used to create the EKS cluster initially, and open the role.
3.  Click the **Trust Relationships** tab.
4.  Click **Edit trust relationship**.
5.  Add the following statement into the Statement list:

```json
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:codebuild:us-east-1:12345678901234:eks-ci-cd-app-deploy"
      },
      "Action": "sts:AssumeRole"
    }
```

```bash
# Copy the ARN of the Fargate pod execution role deployed above in EksStack.  It's visible in the
# deploy **Outputs** and looks like arn:aws:iam::123:role/eks-role.  Then, create the Fargate profile
# to target CoreDNS pods using that role by passing in the role ARN with --pod-execution-role-arn.
aws eks create-fargate-profile \
    --fargate-profile-name profile-eks-fargate-cluster \
    --cluster-name eks-fargate-cluster \
    --pod-execution-role-arn  \
    --selectors namespace=kube-system,labels={k8s-app=kube-dns}

# Remove eks.amazonaws.com/compute-type : ec2 annotation from CoreDNS pods
k patch deployment coredns \
        -n kube-system \
        --type json \
        -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
```

## Destroy Stack

```bash
# Destroy the CI/CD pipeline
cdk destroy cicd
```
