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
        GIT_AUTH = credentials('git')
      }
      steps {
        
         
        
          sh "git clone  https://github.com/pradeep1278/deployrepo.git" 
          sh "git config  user.email pradks.pradeep@gmail.com"
          sh "git config  user.name 'pradeep1278'"
          sh "git config --global push.default matching"
          sh "git config --global push.default simple"

        
          dir("deployrepo") {

            sh "cd ./e2e && /usr/local/bin/kustomize edit set image 10.101.209.206:8761/dockertest:${env.GIT_COMMIT}"
            
         
            sh "git commit -am 'Publish new version'"
           
            
            sh('''
                    git config --local credential.helper "!f() { echo username=\\$GIT_AUTH_USR; echo password=\\$GIT_AUTH_PSW; }; f"
                    git push
                ''')
            
         }
      }
      }
  // }

   stage('Deploy to Prod') {
     environment {
        GIT_AUTH = credentials('git')
      }
      steps {
        input message:'Approve deployment?'
       
          sh "git config  user.email pradks.pradeep@gmail.com"
          sh "git config  user.name 'pradeep1278'"
          sh "git config --global push.default matching"
          sh "git config --global push.default simple"
          
           dir("deployrepo") {

            sh "cd ./prod && /usr/local/bin/kustomize edit set image 10.101.209.206:8761/dockertest:${env.GIT_COMMIT}"
            
         
            sh "git commit -am 'Publish new version'"
           
            
            sh('''
                    git config --local credential.helper "!f() { echo username=\\$GIT_AUTH_USR; echo password=\\$GIT_AUTH_PSW; }; f"
                    git push
                ''')
            
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
