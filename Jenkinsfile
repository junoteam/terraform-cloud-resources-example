pipeline {
    agent any
    
    options { ansiColor('xterm') }

    environment {
        PATH="/var/jenkins_home/tools:${env.PATH}"
    }

    stages {
        stage ('Checkout Repo') {
            steps {
                cleanWs()
                sh  'git clone https://github.com/UnixArena/terraform-test.git'
            }
        }

        stage ('Install Terraform') {
            steps {
                sh '''
                curl -k -o /tmp/terraform_1.4.6_darwin_arm64.zip -C - "https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_darwin_arm64.zip" && unzip /tmp/terraform_1.4.6_darwin_arm64.zip -d /var/jenkins_home/tools/terraform && chmod a+x /var/jenkins_home/tools/terraform
            '''
            }
        }

        stage ('Terraform version') {
            steps {
                sh '''
                terraform --version
                '''
            }
        }

        stage ('Terraform init') {
            steps {
                sh '''
                cd terraform-test/
                terraform init
                '''
            }
        }
        stage ('Terraform plan') {
            steps {
                sh '''
                cd terraform-test/
                terraform plan -out=tfplan.out
                terraform show -json tfplan.out
                '''
            }
        }
    }
}
