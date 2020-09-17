#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CicdStack } from '../lib/ci-cd-stack';

const app = new cdk.App();
new CicdStack(app, 'cicd', {
  stackName: 'eks-app-ci-cd',
  description: 'Application CI-CD'
});
