pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building the wordsmith API application...'
        sh 'docker build -t wordsmithwebimage .'
      }
    }
    stage('Push')  {
      steps {
        echo 'pushing image to dockerhub'
        sh 'docker tag wordsmithWebImage pheyishayor001/wordsmithwebimage'
        sh 'docker login -u="pheyishayor001" -p="simplepass"'
        sh 'docker push pheyishayor001/wordsmithwebimage'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'
        sh 'docker run -d -p 80:80 pheyishayor001/wordsmithwebimage'
      }
    }
  }
}
