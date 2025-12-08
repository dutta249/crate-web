pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-south-1'                 // change region
    ECR_REPO = '330843237346.dkr.ecr.ap-south-1.amazonaws.com/crate-web-frontend'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker --version'
        sh "docker build -t ${ECR_REPO}:${IMAGE_TAG} ."
      }
    }

    stage('Login to ECR') {
      steps {
        // Jenkins must have AWS CLI credentials or instance role
        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO.split('/')[0]}"
      }
    }

    stage('Push to ECR') {
      steps {
        sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
      }
    }

    stage('Deploy to EC2') {
      steps {
        // Option A: use SSH
        // Make sure Jenkins has the private key and EC2 allows your SSH source (or you use a bastion)
        // Replace ubuntu@<ec2-private-ip> with the host reachable from Jenkins (via VPN, bastion, or if Jenkins is inside same VPC)
        sh """
          ssh -o StrictHostKeyChecking=no ubuntu@172.31.60.250'
            docker pull ${ECR_REPO}:${IMAGE_TAG} &&
            docker stop crate_web || true &&
            docker rm crate_web || true &&
            docker run -d --name crate_web -p 80:80 ${ECR_REPO}:${IMAGE_TAG}
          '
        """
        
      }
    }
  }

  post {
    failure {
      echo 'Build failed'
    }
  }
}

