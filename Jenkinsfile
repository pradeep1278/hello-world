#!groovy

pipeline {  
  environment {
    registry = "10.101.209.206:8761/dockertest"
    registryCredential = "dockerhub"
    dockerImage = ''   
}
     agent any
    tools {
        
        maven "M2_HOME" // You need to add a maven with name "3.6.0" in the Global Tools Configuration page
    }

    stages {
        stage("Build") {
            steps {
                sh "mvn -version"
                sh "mvn clean install package"
            }
        }
    
     
       stage('BuildImage') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub')
      }
      steps {
         container('docker') {
          // Build new image
          sh "until docker ps; do sleep 3; done && docker build -t 10.101.209.206:8761/dockertest:${env.GIT_COMMIT} ."
          // Publish new image
          sh "docker login --username $DOCKERHUB_CREDS_USR --password $DOCKERHUB_CREDS_PSW && docker push 10.101.209.206:8761/dockertest:${env.GIT_COMMIT}"
         }
      }
    }
       
       
    
    stage('Deploy E2E') {
      environment {
        GIT_CREDS = credentials('git')
      }
      steps {
        container('tools') {
          sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/alexmt/argocd-demo-deploy.git"
          sh "git config --global user.email 'ci@ci.com'"

          dir("argocd-demo-deploy") {
            sh "cd ./e2e && kustomize edit set image alexmt/argocd-demo:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }

    stage('Deploy to Prod') {
      steps {
        input message:'Approve deployment?'
        container('tools') {
          dir("argocd-demo-deploy") {
            sh "cd ./prod && kustomize edit set image alexmt/argocd-demo:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }
        
       
    }

    post {
        always {
            cleanWs()
        }
    }
}
