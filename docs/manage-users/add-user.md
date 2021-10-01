# Add User

NOTE: Some of the steps must be done by the administrator who already has access to Cromwell server (someone who can SSH into the server).

## Overview

1. Allow new user to SSH into the Cromwell server.
1. New user logs in to the Cromwell server and sets up a password for the Workflow System.
1. Submit a test workflow using the password.

## 1. Retrieve the Public Key

_Give the following instructions to new user:_

---
Run the following command to retrieve the public key for your key pair:

```
ssh-keygen -y -f my-key-pair.pem > my-key-pai.pem.public
```

where `my-key-pair.pem` is your existing EC2 key pair. Your public key will be retrieved and stored in `my-key-pair.pem.public`. You should send the generated public key to the administrator.

If the command fails, run the following command first to ensure that you've changed the permissions on your private key pair file so that only you can view it.

```
chmod 400 my-key-pair.pem
```

## 2. Add Public Key to the `authorized_keys`

_This is the instructions for the administrator:_

---
SSH into the Cromwell server instance and add the new user's public key to the `authorized_keys` file:

```
echo 'ssh-rsa AAAAB3...PLE' >> /home/ec2-user/.ssh/authorized_keys
```

where `ssh-rsa AAAAB3...PLE` is the new user's public key.

Once done, ask the new user if he/she can SSH into the Cromwell server using his/her own EC2 key pair.

## 3. Set Up Password for Workflow System

_This is the instructions for the new user:_

---
SSH into the Cromwell server using your EC2 key pair:

```
ssh -i my-key-pair.pem ec2-user@ec2-w-x-y-z.compute-1.amazonaws.com
```

Run the following command to set up a password. Replace `chunj` with your user name. The command will prompt you for your password. Enter a strong password.

```
sudo htpasswd /etc/apache2/.htpasswd chunj
```

Log out.

On your computer, create a secrets file (a JSON file containing your username, password, and the server URL) and save it as `cromwell-secrets.json`. This file will be needed when you submit your job.

```json
{
    "url": "http://ec2-100-26-88-232.compute-1.amazonaws.com",
    "username": "YOUR-USER-NAME",
    "password": "YOUR-PASSWORD"
}
```

## 4. Submit Test Workflow

Follow the [instructions here](../../test-workflow/README.md) and submit a test workflow.
