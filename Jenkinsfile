pipeline {
    agent {
        label 'dockerbuild'
    }

    /////////////////////////////////////////////////////////////////////
    // START :
    // Definition of Jenkins job configuration
    /////////////////////////////////////////////////////////////////////
    options {
        skipStagesAfterUnstable()
    }
    environment {
        artifactory_url='https://petclinic.jfrog.io/artifactory'
        artifactory_repo="${artifactory_url}/spring-petclinic"
    }
    /////////////////////////////////////////////////////////////////////
    // END
    /////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////
    // START : Stages
    /////////////////////////////////////////////////////////////////////
    stages {
        stage('build and install') {
            steps {
                echo "build <<< ${BUILD_NUMBER} >>> starting..."
				sh "./mvnw -DskipTests clean compile install"
            }
        }
		stage('run tests') {
            steps {
				sh "./mvnw test"
            }
        }
        stage('package application') {
            steps {
                sh "./mvnw package"
                sh "ls -la target"
            }
        }
        stage('push artifact to artifactory') {
            steps {
                echo "--------------------Start - Push to JFROG Artifactory------------------------"
                sh 'curl -u jfroguser:AdminPassword1 -T ./target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar "${artifactory_repo}/spring-petclinic-2.4.0.BUILD-${BUILD_NUMBER}.jar"'
                echo "--------------------Complete - Push to JFROG Artifactory------------------------"
            }
        }
        stage('build docker image') {
            steps {
                script {
                    dockerImage = docker.build "mpatel011/spring-petclinic:$BUILD_NUMBER"
                }

                sh "docker images"
            }
        }
        stage('push docker image to Dockerhub') {
            steps {
                script {
                    docker.withRegistry('' , 'dockerhub') {
                        dockerImage.push()
                    }
                }
            }
        }
	    stage('push docker image to JFrog') {
			steps{
				script {
					sh 'docker login -u "jfroguser" -p "AdminPassword1" https://petclinic.jfrog.io'
                    dockerImage = docker.build "spring-petclinic-docker-images/spring-petclinic:$BUILD_NUMBER"
                    docker.withRegistry('https://petclinic.jfrog.io') {
						dockerImage.push()
					}
                }
			}
		}
        stage ('print job summary') {
            steps {
                echo "----Git repo link: https://github.com/mnpatel0611/spring-petclinic"
                echo "------------------------------------------------"
                echo "--------------------Job Summary Info------------------------"
                echo "Artifact URL: ${artifactory_repo}/spring-petclinic-2.4.0.BUILD-${BUILD_NUMBER}.jar"
                echo "Docker image pushed to Dockerhub: mpatel011/spring-petclinic:$BUILD_NUMBER"
                echo "Docker image pushed to JFrog: ${artifactory_repo}/spring-petclinic-docker-images/spring-petclinic"
                echo "------------------------------------------------"
                echo "------------------------------------------------"
            }
        }
    }

    /////////////////////////////////////////////////////////////////////
    // END : Stages
    /////////////////////////////////////////////////////////////////////

}
