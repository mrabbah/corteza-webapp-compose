pipeline {
    agent {
        docker { image 'node:16.16.0' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'yarn install'
                sh 'yarn test:unit'
            }
        }
        stage('Build') {
            steps {
                sh 'yarn build'
            }
        }
    }
}
