pipeline {
   agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                metadata:
                  namespace: ci
                  labels:
                    pod-name: corteza-server-builder
                spec:
                  containers:
                    - name: node
                      image: node:16.16.0
                      command: ["tail", "-f", "/dev/null"]
                      tty: true
                    - name: mc
                      image: mrabbah/mc:1.2
                      command: ["tail", "-f", "/dev/null"]
                      tty: true 
                    - name: docker-daemon
                      image: docker:20.10.21-dind
                      securityContext:
                        privileged: true
                      env:
                        - name: DOCKER_TLS_CERTDIR
                          value: ""     
                      resources: 
                        requests:
                          cpu: 1
                          memory: 1Gi
                        limits:
                          cpu: 4
                          memory: 4Gi
                    - name: docker
                      image: docker:20.10.21
                      command:
                        - sleep
                      args:
                        - 99d
                      env:
                        - name: DOCKER_HOST
                          value: tcp://localhost:2375                       
                '''
                //workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'pvc-workspace', readOnly: false)
                //workspaceVolume dynamicPVC(accessModes: 'ReadWriteOnce', requestsSize: "8Gi")
        }      
    }
   

    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
        BRANCH_NAME = "${GIT_BRANCH.split('/').size() > 1 ? GIT_BRANCH.split('/')[1..-1].join('/') : GIT_BRANCH}"
        MINIO_CREDS = credentials('minio-credentials')
        MINIO_HOST = "http://minio.data:9000"
    }
    stages {
        stage('Test') {
            steps {
              container('node') {
                //sh 'git reset --hard  && git clean -fdx --exclude="/node_modules/"'
                sh 'yarn install'
                sh 'yarn test:unit'
              }
            }  
        }
        stage('patch') {
            
            steps {
                container('mc') {
                  sh 'rm -fr corteza-webapp-compose-patch && mkdir corteza-webapp-compose-patch'
                  sh 'mc --config-dir /tmp/.mc alias set minio $MINIO_HOST $MINIO_CREDS_USR $MINIO_CREDS_PSW'
                  sh 'mc --config-dir /tmp/.mc cp minio/corteza-artifacts/corteza-webapp-compose-patch-${BRANCH_NAME}.tar.gz ./corteza-webapp-compose-patch '
                  sh 'cd corteza-webapp-compose-patch && ls &&  tar xf corteza-webapp-compose-patch-${BRANCH_NAME}.tar.gz && rm -fr *.tar.gz && ls && cd ..'
                  sh 'ls && cp -R ./corteza-webapp-compose-patch/corteza-webapp-compose-patch/* ./src'
                }
           }
        }
        stage('Prepare') {
            
            steps {
                container('mc') {
                    sh 'rm -fr corteza-blocks/ && rm -fr corteza-js && rm -fr corteza-block-scripts'
                    sh 'mkdir corteza-blocks'
                    sh 'mc --config-dir /tmp/.mc alias set minio $MINIO_HOST $MINIO_CREDS_USR $MINIO_CREDS_PSW'
                    sh 'mc --config-dir /tmp/.mc find minio/corteza-blocks-artifacts --name "*r2022.3.1.x*" --exec "mc --config-dir /tmp/.mc cp {} ./corteza-blocks"'
                    sh 'cd corteza-blocks && ls && for f in *.tar.gz; do tar xf "$f"; done && rm -fr *.tar.gz && ls && cd ..'
                    sh 'git clone --branch ${BRANCH_NAME} https://github.com/mrabbah/corteza-js.git'
                    sh 'mc --config-dir /tmp/.mc cp minio/corteza-artifacts-public/corteza-block-scripts-${BRANCH_NAME}.tar.gz  . && tar xf corteza-block-scripts-${BRANCH_NAME}.tar.gz && rm -f corteza-block-scripts-${BRANCH_NAME}.tar.gz'
                    sh 'pwd && for f in corteza-blocks/* ; do echo "$f" && echo $(basename $f | sed -e "s/corteza-//g" | sed -e "s/-block//g") && ./corteza-block-scripts/bin/patch.sh "$f"  corteza-js/ ./ $( basename $f | sed -e "s/corteza-//g" | sed -e "s/-block//g"); done'
              }
           }

        }
        stage('Build') {
           
            steps {
               container('node') {
                  sh 'cd corteza-js && yarn install && yarn build && cd ..'
                  sh 'cp -r ./corteza-js/dist/. ./node_modules/@cortezaproject/corteza-js/dist'
                  sh 'rm -fr corteza-blocks/ && rm -fr corteza-js && rm -fr corteza-block-scripts'
                  sh 'yarn build'
               }
            }
        }
        stage('Publish') {
           
            steps {
               container('mc') {
                  sh 'mc --config-dir /tmp/.mc alias set minio $MINIO_HOST $MINIO_CREDS_USR $MINIO_CREDS_PSW'
                  sh 'cd dist && tar -czf ../corteza-webapp-compose-${BRANCH_NAME}.tar.gz .'
                  sh 'mc --config-dir /tmp/.mc cp ./corteza-webapp-compose-${BRANCH_NAME}.tar.gz minio/corteza-artifacts'
               }
            }
        }
        stage('Build Docker image') {

            steps {
                container('docker') {
                sh 'docker build -t mrabbah/corteza-webapp-compose:${BRANCH_NAME} --build-arg VERSION=${BRANCH_NAME} . '
                }
            }
        }

        stage('Push Docker image') {

            steps {
                container('docker') {
                  echo 'Pushing docker image'
                  script {
                      sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
                      sh 'docker push mrabbah/corteza-webapp-compose:${BRANCH_NAME}'
                  }
               }
            }
        }
         
    }
}
