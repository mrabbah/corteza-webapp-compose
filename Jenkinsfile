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
        stage('Publish') {
            environment {
                NEXUS_CREDS = credentials('nexus-raw-repo-credentials')
            }
            steps {
                sh 'tar -C $PWD/dist -czf corteza-webapp-compose-${GIT_BRANCH}.tar.gz $PWD/dist'
                sh 'ls .'
                sh 'tree .'
                sh 'echo ${NEXUS_CREDS}'
                sh 'curl -v --user ${NEXUS_CREDS} --upload-file ./corteza-webapp-compose-${GIT_BRANCH}.tar.gz https://nexus.rabbahsoft.ma/repository/row-repo/corteza-webapp-compose-${GIT_BRANCH}.tar.gz'
            }
        }

    }
}
