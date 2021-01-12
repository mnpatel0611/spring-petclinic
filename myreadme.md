## Steps:
1. Steup Docker locally (https://docs.docker.com/docker-for-mac/install/)
2. Download Jenkins docker image and Run
	 - `sudo docker pull jenkins/jenkins:lts`
   - `sudo docker run -p 8081:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts`
3. Install Git, Artifactory, Docker Pipeline plugins
4. Created two jobs \
4.1 spring-PetClinic (Freestyle project) \
-- Set Docker registry URL in config - https://hub.docker.com/repository/docker/mpatel011/spring-petclinic  \
-- Set Source Control Management to Git in config \
-- Under `Build Environment` Checked Maven3-Artifactory Integration \
---- Set Artifactory Server - https://petclinic.jfrog.io/artifactory \
---- Target release repository - spring-petclinic  \
---- Target snapshots repository - spring-petclinic \
-- Under `Build` add `Execute shell` and add below to list and push image to Dockerhub \
```
docker images
docker build . -t mpatel011/spring-petclinic:$BUILD_NUMBER
docker push mpatel011/spring-petclinic:$BUILD_NUMBER
```
4.2 spring-petclinic-pipeline (Pipeline) \
-- Set Source Control Management to Git in config \
-- Give script path to Jenkinsfile path \
-- Save and run Build

## Build Tasks
1. Push artifact to JFrog Artifactory (hosted on cloud) https://petclinic.jfrog.io/artifactory/spring-petclinic
2. Push Docker image to Dockerhub https://hub.docker.com/repository/docker/mpatel011/spring-petclinic
3. Push Docker image to JFROG https://petclinic.jfrog.io/artifactory/spring-petclinic-docker-images/spring-petclinic

## Download Docker image from Dockerhub:
```docker pull mpatel011/spring-petclinic:{BUILD_NUMBER}```

## Run Docker image locally:
1. docker run -p 9449:8080 mpatel011/spring-petclinic:{BUILD_NUMBER}
2. http://localhost:9449/
