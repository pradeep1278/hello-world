#!groovy

pipeline {
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
    
    stage("Image creation") {
            steps {
    
    sshPublisher(publishers: [sshPublisherDesc(configName: 'rpak8worker01', 
    transfers: [sshTransfer(excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: 'webapp/target', sourceFiles: '**/target/*.war')], 
                                                  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
    
    sh "cd /root ;docker build -t  devops-image ."            
                
    }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
