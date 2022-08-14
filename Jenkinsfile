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
                sh 'tar -C dist -czf corteza-webapp-compose-${GIT_BRANCH}.tar.gz dist'
                sh 'ls dist'
                sh 'curl -v --user "${NEXUS_CREDS}" --upload-file .dist/corteza-webapp-compose-${GIT_BRANCH}.tar.gz https://nexus.rabbahsoft.ma/repository/row-repo/corteza-webapp-compose-${GIT_BRANCH}.tar.gz'
            }
        }

    }
}
