# How to Add Larger Instance Types

## Overview

1. Create a new compute environment in AWS Batch with additional EC2 instance types.
1. Associate the new compute environment to the priority job queue.
1. Remove the old compute environment.

To do this, you need to make some changes in `Job Queues` and `Compute Environments`.

![](../../images/alit/aws-batch-left-panel.png)

## Clone the Existing Compute Environment

![](../../images/alit/00.png)

## Give New Name

![](../../images/alit/01-01.png)

## Set EC2 Keypair

Expand the option `Additional settings: service role, instance role, EC2 key pair`

![](../../images/alit/01-02.png)

## Add Additional Instance Types

- `c5.9xlarge`: 72.0 GiB / 36 vCPUs
- `c5n.9xlarge`: 96.0 GiB / 36 vCPUs
- `m5.8xlarge`: 128.0 GiB / 32 vCPUs
- `m5.12xlarge`: 192.0 GiB / 48 vCPUs
- `m5n.8xlarge`: 128.0 GiB / 32 vCPUs
- `m5n.12xlarge`: 192.0 GiB / 48 vCPUs
- `r5.8xlarge`: 256.0 GiB / 32 vCPUs
- `r5.12xlarge`: 384.0 GiB / 48 vCPUs
- `r5n.8xlarge`: 256.0 GiB / 32 vCPUs
- `r5n.12xlarge`: 384.0 GiB / 48 vCPUs

![](../../images/alit/02.png)

## Set Allocation Strategy

![](../../images/alit/03-01.png)

## Set Launch Template

Expand the option `Additional settings: launch template, user specified AMI`

![](../../images/alit/03-02.png)

## Set EC2 Tag

![](../../images/alit/04.png)

## Save

Click the `Create compute environment` button to save the changes.

## Add New Compute Environment to Priority Job Queue

Choose the queue that your new compute environment to be added to.

![](../../images/alit/05.png)

Select your new compute environment and make sure to move it to the top of the order so that it can be used before any other environment (or remove all other environments).

![](../../images/alit/06.png)
