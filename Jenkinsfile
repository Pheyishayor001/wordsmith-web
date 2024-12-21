pipeline {
  agent any
  stages {
    stage('scan files') {
      steps {
        echo 'Scaning files with sonar-scanner'
        
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
        sh 'docker build -t wordsmithwebimage .'
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
        sh 'docker run -d -p 80:80 pheyishayor001/wordsmithwebimg:${BUILD_ID}'
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
