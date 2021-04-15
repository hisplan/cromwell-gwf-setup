# cromwell-gwf-setup

Setting up Cromwell + AWS GWF (Genomics Workflow)

## Install the Genomics Workflow Core

Use the CloudFormation template.

## Install the Cromwell Server

Use the CloudFormation template.

## Download the Setup Package

SSH into the Cromwell server ec2 instance. Run the following command to download the setup package (the repository must be publicly accessible):

```bash
$ wget https://github.com/hisplan/cromwell-gwf-setup/archive/refs/tags/v0.0.1-alpha.2.tar.gz
```

Decompress:

```bash
$ tar xvzf cromwell-gwf-setup-0.0.1-alpha.2.tar.gz --strip-components=1
```

## Set Up

Run the following command to install Redis and Cromsfer:

```bash
$ ./install.sh
```

## Configure Cromsfer

```bash
$ cp ./config/cromsfer/config.template.yaml ./cromsfer/config.yaml
```

Open the `./cromsfer/config.yaml` file and replace `ec2-w-x-y-z.compute-1.amazonaws.com` with your actual public IPv4 DNS name:

```yaml
cromwell:
  url: http://ec2-100-26-88-232.compute-1.amazonaws.com
  username: user1
  password: 123
redis:
  host: ec2-100-26-88-232.compute-1.amazonaws.com
  port: 6379
```

## Configure Job Manager

```bash
$ cp ./config/job-manager/capabilities-config.json ./jmui/bin/capabilities-config.json
```

## Start

```bash
$ ./startup.sh
```
