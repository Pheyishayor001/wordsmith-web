pipeline {
  agent any
  tools {
      go 'myGo'
      // sonarQube 'sonar-scanner_install'
    }
  environment {
        // Define SonarQube server and token
        SONARQUBE_SERVER = 'new_sonar_scanner'
    }
  stages {
    stage('scan files') {
      steps {
        echo 'Scaning files with sonar-scanner'
        withSonarQubeEnv('new_sonar_scanner') {
        sh '''
        /opt/sonar-scanner/bin/sonar-scanner \
          -Dsonar.projectKey=goProjectScan \
          -Dsonar.sources=. \
          -Dsonar.host.url=http://18.234.175.158:9000 \
          -Dsonar.login=sqp_963818367940ddf1af777b08e5685c5ed43f03b2

        '''
        }
      }
    }
    stage('build artifact') {
      steps {
        echo 'Building the artifact'
        sh '''
        go mod init wordsmith
        go mod tidy
        go build -o wordsmith dispatcher.go
        '''
      }
    }
    stage('Push to nexus') {
      steps {
        echo 'Pushing image to nexus artifactory...'        
      }
    }
    stage('Build docker image') {
      steps {
        echo 'Building the wordsmith API application...'
        sh 'docker build -t wordsmithwebimg .'
      }
    }
    stage('Push image to dockerhub')  {
      steps {
        echo 'pushing image to dockerhub'
        sh '''
        docker tag wordsmithwebimg pheyishayor001/wordsmithwebimg:${BUILD_ID}
        docker login -u="pheyishayor001" -p="simplepass"
        docker push pheyishayor001/wordsmithwebimg:${BUILD_ID}       
        '''
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'
        sh 'ssh -o StrictHostKeyChecking=no -i "../network.pem" ec2-user@3.86.140.57 -t "docker ps -aq | xargs docker rm -f; docker run -d -p 80:80 pheyishayor001/wordsmithwebimg:${BUILD_ID}"'
      }
    }
  }
  post {
    always {
      // One or more steps need to be included within each condition's block.
      cleanWs()
    }
    success {
      echo "Build completed successfully. Performing success-specific actions..."
    }
    failure {
      echo "Build failed. Performing failure-specific cleanup actions..."
    }
  }
}
