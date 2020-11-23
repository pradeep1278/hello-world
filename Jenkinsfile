#!groovy

pipeline {
   
  environment {
    registry = "dockerregistrylogin/test"
    registryCredential = 'dockerregistrylogin'
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
    
    stage("copy artifacts") {
            steps {    
    sshPublisher(publishers: [sshPublisherDesc(configName: 'rpak8sworker01', 
    transfers: [sshTransfer(excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: 'webapp/target', sourceFiles: '**/target/*.war')], 
                                                  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
    
    
                           
                
    }
        }
       
    
    } 
        
        
        
        
        stage('Image Build') {
            
        
         environment {
        DOCKERHUB_CREDS = credentials('dockerregistrylogin')
      }
      steps {
       // container('docker') {
          // Build new image
          
         sh "/usr/bin/docker build -t dockerregistrylogin/argocd-demo:${env.GIT_COMMIT} ."
          // Publish new image
          sh "/usr/bin/docker login --username $DOCKERHUB_CREDS_USR --password $DOCKERHUB_CREDS_PSW   && /usr/bin/docker push dockerregistrylogin/argocd-demo:${env.GIT_COMMIT}"
        }
      }
    //}

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