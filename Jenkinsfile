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
                sh 'yarn install'
                // sh 'yarn test:unit'
            }
        }
        stage('build_composant') {
          environment {
                NEXUS_CREDS = credentials('nexus-credentials')
            }
            steps {
              sh 'rm -fr corteza-blocks/'
              sh 'rm -fr corteza-js'
              sh 'mkdir corteza-blocks '
              sh 'curl -o corteza-blocks/corteza-helloworld-block-${BRANCH_NAME}.tar.gz -v --user $NEXUS_CREDS https://nexus.rabbahsoft.ma/repository/row-repo/corteza-helloworld-block-${BRANCH_NAME}.tar.gz'
              sh 'tar  -xf corteza-blocks/corteza-helloworld-block-${BRANCH_NAME}.tar.gz  '
              sh 'curl -o corteza-blocks/corteza-maps-block-${BRANCH_NAME}.tar.gz -v --user $NEXUS_CREDS https://nexus.rabbahsoft.ma/repository/row-repo/corteza-maps-block-${BRANCH_NAME}.tar.gz'
              sh 'tar  -xf corteza-blocks/corteza-maps-block-${BRANCH_NAME}.tar.gz  '
              sh 'git clone --branch ${BRANCH_NAME} https://github.com/mrabbah/corteza-js.git'
              sh 'ls corteza-blocks/corteza-helloworld-block  '
              sh 'ls corteza-blocks/corteza-maps-block  '
              sh './add.sh corteza-blocks/corteza-maps-block  corteza-js/ ./'
              sh './add.sh corteza-blocks/corteza-helloworld-block  corteza-js/ ./'
              sh 'cd corteza-js && yarn install && yarn build && cd ..'
              sh 'cp -r ./corteza-js/dist/. ./node_modules/@cortezaproject/corteza-js/dist'
            }


        }
        stage('Build') {
            steps {
              sh 'yarn build'
            }
        }
        stage('Publish') {
            environment {
                NEXUS_CREDS = credentials('nexus-credentials')
            }
            steps {
              sh 'tar -C $PWD/dist -czf corteza-webapp-compose-${BRANCH_NAME}.tar.gz $PWD/dist'
              sh 'curl -v --user $NEXUS_CREDS --upload-file ./corteza-webapp-compose-${BRANCH_NAME}.tar.gz https://nexus.rabbahsoft.ma/repository/row-repo/corteza-webapp-compose-${BRANCH_NAME}.tar.gz'
            }
        }

    }
}
