pipeline {
    agent {
        label 'agent1'
    }

    environment {
        IMAGE_NAME = 'itaykalininsky/app'
        IMAGE_TAG = '1.0.0'
        DOCKER_CREDENTIALS_ID = 'docker_hub_credentials'
        GITHUB_ID = 'GitHub_User2'
        GITHUB_BRANCH = 'main'
        GITHUB_URL = 'https://github.com/The-LittleTeapot/ArgoCD-Helm.git'
        WEATHERAPP_RUNNING = false
        EKS_URL = ''
        //DOCKER_CONTEXT = '172.31.39.24:2375'
    }

    stages {
        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASSWORD docker.io'
                }
            }
        }

        stage(' Clone GitHub repo') {
            steps {
                sh 'mkdir -p github_repo'
                dir('github_repo') {
                    git branch: "${GITHUB_BRANCH}", credentialsId: "${GITHUB_ID}", url: "${GITHUB_URL}"
                }
            }

        }

        stage('Increment Version') {
            steps {
                dir('github_repo'){
                    script {
                        def NEW_IMAGE_TAG = sh(script: './version.sh -v ${IMAGE_TAG} -p', returnStdout: true).trim()
                        env.IMAGE_TAG = NEW_IMAGE_TAG
                        echo "New Image Tag: ${IMAGE_TAG}"
                    }
                }

            }
        }

        // stage('Build') {
        //     steps {
        //         dir('python_weatherapp') {
        //             // sh 'docker context use default'
        //             sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
        //         }
        //     }
        // }

        // stage('Publish to Docker Hub') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
        //             sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} docker.io"
        //             sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
    
        //         }
        //     }
        // }

        stage(' Update GitHub repo') {
            steps {
                sh 'mkdir -p github_repo'
                dir('github_repo') {
                    script {
                        sh "sed -i '' -e 's/itaykalininsky/app:.*/itaykalininsky/app:${IMAGE_TAG}/g' /Helm/templates/weatherapp-deployment.yaml"
                        sh  "git add ."
                        sh  "git commit -m 'Update image tag to ${IMAGE_TAG}'"
                        sh  "git push origin '${GITHUB_BRANCH}'"
                    }

                }
            }

        }
        
      
      
        // stage('Deploy to EKS') {
        //     steps {
        //         withKubeConfig([credentialsId: 'EKS_USER', serverUrl: "${EKS_URL}"]) {
        //             sh "helm upgrade --reuse-values --set weatherAppImage.repository=${IMAGE_NAME} --set weatherAppImage.tag=${BUILD_NUMBER} weatherapp EKS_Jenkins/flask-app"
        //     }
        // }

        
        // stage('Deploy to EC2') {
        //     steps {
        //         sh 'docker context create --docker host=tcp://172.31.36.55:2375 weatherapp-server || true'
        //         sh 'docker context use weatherapp-server'
        //         sh 'docker pull $IMAGE_NAME'
        //         sh 'docker stop weatherapp || true'
        //         sh 'docker run -d --rm --name weatherapp -p 80:80 $IMAGE_NAME'
        //         sh 'docker context use default'

       
        //     }
        // }
    }
    // post {
    //     always {
    //         slackSend(
    //         botUser: true, 
    //         channel: 'builds', 
    //         color: 'good', 
    //         message: 'Testing Passed, App is deployed!', 
    //         tokenCredentialId: 'slack-token'
    //         )
    //         script {
    //             if (WEATHERAPP_RUNNING == true) {
    //                 sh 'docker kill weatherapp'
    //             }
    //         }
    //     }
    //      failure {
    //         slackSend(
    //         botUser: true, 
    //         channel: 'builds', 
    //         color: 'bad', 
    //         message: 'Testing Failed', 
    //         tokenCredentialId: 'slack-token'
    // blablaasdasd
    //         )
    //     }
    // }
}       


