## Author : ARUNKUMAAR R
## Description : Jenkins Pipeline file 
## Date : 14/02/24
## Language : Groovy

pipeline {
    
	agent any
    tools {
        maven "M2"
        jdk "JAVA_HOME"
    }
	
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUSPORT = "8081"
        NEXUSIP = "172.31.23.80"
        SNAP_REPO = 'CI-CD-snapshot'
        NEXUS_USER = 'admin'
        NEXUS_PASS = 'admin'
        RELEASE_REPO = "CI-CD-release"
        NEXUS_GRP_REPO = "CI-CD-group"
        NEXUS_LOGIN = "nexus-credential"
        SONARSERVER = 'SonarServer'
        SONARSCANNER = 'SonarScanner'
        
    }
	
    stages {
        stage('build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
        
            post {
                success {
                    echo "now archieved"
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }            

        stage('Test'){
            steps {
                sh 'mvn -s settings.xml test'
            }
        }

        stage('checkStyle'){
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }

     
        stage('Sonar Analysis'){
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                   sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''

            }
        }
    }
        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'CI-CD',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                  ]
                )
            }
        }
    }
    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#CI-CD_Jenkins',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
    
}




