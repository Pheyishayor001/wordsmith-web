pipeline {
  agent none
  stages {
    stage('Build') {
      steps {
        echo 'Building the wordsmith API application...'
        sh 'docker build -t wordsmithWebImage .'
      }
    }
    stage('Push')  {
      steps {
        echo 'pushing image to dockerhub'
        sh 'docker tag wordsmithWebImage pheyishayor001/wordsmithWebImage'
        sh 'docker login -u="pheyishayor001" -p="simplepass"'
        sh 'docker push pheyishayor001/wordsmithWebImage'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying the application'
        sh 'docker run -d -p 80:80 pheyishayor001/wordsmithWebImage'
      }
    }
  }
}
