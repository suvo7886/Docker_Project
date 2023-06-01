pipeline {
    agent any
    tools {
	jdk "JAVA_HOME"
        maven "M2_HOME"
    }
	environment {	
	   DOCKERHUB_CREDENTIALS=credentials('Docker_Hub')
	} 
    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/suvo7886/Docker_Project_StarAgile.git'
            }
		}
        stage('Maven Build') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
		}
        stage("Docker Build"){
            steps {
				sh 'docker version'
				sh "docker build -t docker build -t cicd-project1:${BUILD_NUMBER} ."
				sh 'docker image list'
				sh "docker tag cicd-project1 suvo7886/cicd-project1:${BUILD_NUMBER} suvo7886/cicd-project1:latest"
            }
        }
		stage('Login to DockerHub') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
        stage('Approve for Push Image to Dockerhub'){
            steps{
                
                //----------------send an approval prompt-------------
                script {
                   env.APPROVED_DEPLOY = input message: 'User input required Choose "Yes" | "Abort"'
                       }
                //-----------------end approval prompt------------
            }
        }
		stage('Push to DockerHub') {

			steps {
				sh "docker push suvo7886/cicd-project1:latest"
			}
		}
        stage('Approve - Deployment to Kubernetes Cluster'){
            steps{
                
                //----------------send an approval prompt-----------
                script {
                   env.APPROVED_DEPLOY = input message: 'User input required Choose "Yes" | "Abort"'
                       }
                //-----------------end approval prompt------------
            }
        }
        stage('Deploy to Kubernetes Cluster') {
            steps {
		script {
		sshPublisher(publishers: [sshPublisherDesc(configName: 'kubernetescluster', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'kubectl apply -f k8smvndeployment.yaml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '.', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '*.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
		}
            }
	}
}
}
