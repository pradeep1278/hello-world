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
    }

    post {
        always {
            cleanWs()
        }
    }
}
