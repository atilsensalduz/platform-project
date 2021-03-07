# Platform Project

This project was created to show how to setup whole infrastructure with infrastructure as code perspective.

## Prerequisites

Before you begin, ensure you have met the following requirements:
* You have a Linux machine for use like bastion server. I use centos 8
* You should create a /workspace directory
* You have installed the latest version of Ansible, Terraform, awscli

## Infrastructure Setup 

Ansible installation:

```
sudo dnf install epel-release
sudo dnf makecache
sudo dnf install ansible

```

Terraform installation:

```
sudo dnf -y install wget
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
unzip terraform_${TER_VER}_linux_amd64.zip
mv terraform /usr/bin/

```

awscli installation:

```
dnf install python3-pip
pip3 install awscli --upgrade --user


```

configure aws credential:

```
aws configure
```

kops user credential requirment 

```
aws iam create-group --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
aws iam create-user --user-name kops
aws iam add-user-to-group --user-name kops --group-name kops
aws iam create-access-key --user-name kops
```


## Using Platform-Project repository 

How to up and running all infrastucture, follow these steps:

```
cd /workspace/ansible
ansible-playbook infra-up.yaml
```

Run command and all infrastructure setup has begun. One ec2 instance for jenkins master and 3 nodes kubernetes cluster. One of them master and other two ec2 instances has worker role. Also all infrastrue in the free tier. I used t2.micro instance type.

Used the jenkins configuration as code plugin and all configuration in the jenkins-casc.yaml.j2. I use ninja template for ansible render all configuration files. You must add all required information in the jenkins.yml playbook.

Used the kops for kubernetes cluster installation on the aws. All kops configuration in the /workspace/kops/ directory. You should change the clustername and kops state s3 bucket name in the /workspace/kops/group_vars/all/vars.yaml.

Wrote the simple web-app for demonstrate purposes. I choose next.js simple random dog image app. Also have /ping and /liveness routes for readiness and liveness probe in the kubernetes deployment.

How to destroy all infrastucture, follow these steps:

```
cd /workspace/ansible
ansible-playbook infra-down.yaml
```

## Contributing to Platform-Project
To contribute to Platform-Project, follow these steps:

1. Fork this repository
2. Clone your fork down to your local machine
`    git clone https://github.com/atileren/platform-project.git`
3. Create a branch
    `git checkout -b branch-name`
4. Make your changes
5. Commit and push
```    
    git add .
    git commit -m 'Commit message'
    git push origin branch-name
```
Create a new pull request from your forked repository (Click the New Pull Request button located at the top of your repo)
Wait for your PR review and merge approval!
Star this repository if you had fun!


Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

## Contact

If you want to contact me you can reach me at atil.eren@outlook.com

