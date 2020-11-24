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
    
     
       stage('Build image') {
    steps{
     
      script {
        
       dockerImage =docker.build registry + ":${env.GIT_COMMIT}"
        
      }
    }
  }

stage('Push Image') {
      steps{
        script {
         docker.withRegistry( "http://10.101.209.206:8761/dockertest", registryCredential ) {
          dockerImage.push()}
         // }
        }
      }
    }
       
       
    
    stage('Deploy E2E') {
      environment {
        GIT_CREDS = credentials('git')
      }
      steps {
        input message:'Approve deployment?'
        
          sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/alexmt/argocd-demo-deploy.git"
          sh "git config --global user.email 'ci@ci.com'"

          dir("argocd-demo-deploy") {
            sh "cd ./e2e && kustomize edit set image alexmt/argocd-demo:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
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
