#!groovy

pipeline {
    environment {
        JAVA_TOOL_OPTIONS = "-Duser.home=/home/jenkins"
    }
    agent {
        dockerfile {
            
            args "-v /tmp/maven:/home/jenkins/.m2 -e MAVEN_CONFIG=/home/jenkins/.m2"
        }
    }

    stages {
        stage("Build") {
            steps {
                sh "ssh -V"
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
   
    post {
        always {
            cleanWs()
        }
    }
}
