pipeline {
    agent {
        docker { image 'node:16.16.0' }
    }
    environment {
        BRANCH_NAME = "${GIT_BRANCH.split('/').size() > 1 ? GIT_BRANCH.split('/')[1..-1].join('/') : GIT_BRANCH}"
    }
    stages {
        stage('Test') {
            steps {
                // sh 'yarn install'
                // sh 'yarn test:unit'
                sh 'echo test'
            }
        }
        stage('Build') {
            steps {
                //sh 'yarn build'
                sh 'echo build'
            }
        }
        stage('Publish') {
            environment {
                NEXUS_CREDS = credentials('nexus-credentials')
            }
            steps {
                // sh 'tar -C $PWD/dist -czf corteza-webapp-compose-${GIT_BRANCH}.tar.gz $PWD/dist'
                sh 'touch corteza-webapp-compose-${BRANCH_NAME}.tar.gz'
                sh 'curl -v --user $NEXUS_CREDS --upload-file ./corteza-webapp-compose-${BRANCH_NAME}.tar.gz https://nexus.rabbahsoft.ma/repository/row-repo/corteza-webapp-compose-${BRANCH_NAME}.tar.gz'
            }
        }

    }
}
