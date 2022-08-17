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
              sh 'ls'
                // sh 'yarn install'
                // sh 'yarn test:unit'
            }
        }
        stage('build_composant') {
          environment {
                NEXUS_CREDS = credentials('nexus-credentials')
            }
            steps {
                 sh 'curl -o corteza-maps-block-${BRANCH_NAME}.tar.gz -v --user $NEXUS_CREDS https://nexus.rabbahsoft.ma/repository/row-repo/corteza-maps-block-${BRANCH_NAME}.tar.gz'
                 sh 'tar -xf corteza-maps-block-${BRANCH_NAME}.tar.gz  '
                 sh 'rm -fr corteza-maps-block-${BRANCH_NAME}.tar.gz'
                 sh 'rm -fr corteza-js'
                 sh 'git clone --branch ${BRANCH_NAME} https://github.com/mrabbah/corteza-js.git'
                 sh 'ls -la'
                 sh 'ls -la corteza-maps-block/'
                 sh './add.sh corteza-maps-block'
                 sh 'git status'

            }


        }
        stage('Build') {
            steps {
              sh 'ls'
                // sh 'yarn build'
            }
        }
        stage('Publish') {
            environment {
                NEXUS_CREDS = credentials('nexus-credentials')
            }
            steps {
              sh 'ls'
                // sh 'tar -C $PWD/dist -czf corteza-webapp-compose-${BRANCH_NAME}.tar.gz $PWD/dist'
                // sh 'curl -v --user $NEXUS_CREDS --upload-file ./corteza-webapp-compose-${BRANCH_NAME}.tar.gz https://nexus.rabbahsoft.ma/repository/row-repo/corteza-webapp-compose-${BRANCH_NAME}.tar.gz'
            }
        }

    }
}
