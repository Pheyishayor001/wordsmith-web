pipeline {
  agent any
  tools {
      go 'myGo'
      // sonarQube 'sonar-scanner_install'
    }
  stages {
    stage('scan files') {
      steps {
        echo 'Scaning files with sonar-scanner'
        
       withCredentials([
         string(credentialsId: 'sonar-token-web', variable: 'SONAR_TOKEN_WEB'),
         string(credentialsId: 'sonar-host-url', variable: 'SONAR_HOST_URL')
        ]) {
        sh '''
        /opt/sonar-scanner/bin/sonar-scanner \
          -Dsonar.projectKey=wordsmith-web-scan \
          -Dsonar.sources=. \
          -Dsonar.host.url=$SONAR_HOST_URL \
          -Dsonar.login=$SONAR_TOKEN_WEB

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
        withCredentials([usernamePassword(credentialsId: 'nexus_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD'),
                        string(credentialsId: 'nexus-host-url', variable: 'NEXUS_HOST_URL')]) {
                echo 'Pushing image to nexus artifactory...' 
                // Example build command
                sh '''
                   curl -u "$USERNAME:$PASSWORD" \
                     --upload-file ./wordsmith \
                         $NEXUS_HOST_URL/repository/wordsmith-go-artifact/
                '''
            }
        
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
        withCredentials([usernamePassword(credentialsId: 'docker_login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        echo 'pushing image to dockerhub'
        sh '''
        docker tag wordsmithwebimg pheyishayor001/wordsmithwebimg:${BUILD_ID}
        docker login -u="$USERNAME" -p="$PASSWORD"
        docker push pheyishayor001/wordsmithwebimg:${BUILD_ID}       
        '''
        }
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'
        // sh 'ssh -o StrictHostKeyChecking=no -i "../network.pem" ec2-user@172.31.93.239 -t "docker ps -aq | xargs docker rm -f; docker run -d -p 80:80 pheyishayor001/wordsmithwebimg:${BUILD_ID}"'
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
