#!groovy

pipeline {  
  environment {
    registry = "10.101.209.206:8761/dockertest"
    registryCredential = "dockerhub"
    dockerImage = ''   
    TAG =''
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
        
         
          sh "git clone https://github.com/pradeep1278/argocd-demo-deploy.git"
           sh  "git config --global credential.helper 'git'"
          sh "git config --global user.email pradeep.kumar@sita.aero"
          sh "git config --global user.name 'pradeep1278'"
          sh "git config --global push.default matching"
          sh "git config --global push.default simple"

          dir("argocd-demo-deploy") {

            sh "cd ./e2e && /usr/local/bin/kustomize edit set image 10.101.209.206:8761/dockertest:${env.GIT_COMMIT}"
            //    TAG=${env.GIT_COMMIT}
             // sh "cd ./e2e &&   sed -i 's/TAG/${env.GIT_COMMIT}/g' ./kustomization.yaml "
            sh "git remote set-url origin https://github.com/pradeep1278/argocd-demo-deploy.git"
            sh "git commit -am 'Publish new version' && git push origin master|| echo 'no changes'"
          }
         
      }
    }

    stage('Deploy to Prod') {
      steps {
        input message:'Approve deployment?'
        
          dir("argocd-demo-deploy") {
            sh "cd ./prod && /usr/local/bin/kustomize edit set image 10.101.209.206:8761/dockertest:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push -u origin master || echo 'no changes'"
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
