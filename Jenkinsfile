pipeline {
  agent {
    node {
      label 'maven'
    }

  }
  stages {
    stage('git pull') {
      agent none
      steps {
        git(credentialsId: 'yukikyu-github', url: 'https://github.com/yukikyu/eureka.git', branch: 'main', changelog: true, poll: false)
      }
    }

    stage('build and push') {
      agent none
      steps {
        container('maven') {
          sh 'mvn -Dmaven.test.skip=true clean package'
          sh 'docker build -f Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BUILD_NUMBER .'
          withCredentials([usernamePassword(credentialsId : 'dockerhub-id' ,passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh '''echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin
'''
            sh '''docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BUILD_NUMBER
'''
          }

        }

      }
    }

    stage('Artifacts') {
      agent none
      steps {
        archiveArtifacts 'target/*.jar'
      }
    }

    stage('Deploy to Dev') {
      agent none
      steps {
        input(message: '@zhouy  ', submitter: 'zhouy')
        container('maven') {
          withCredentials([kubeconfigContent(credentialsId : 'demo-kubeconfig' ,variable : 'KUBECONFIG_CONTENT' ,)]) {
            sh '''mkdir ~/.kube

echo "$KUBECONFIG_CONTENT" > ~/.kube/config

pwd

envsubst < deploy/deploy.yml | kubectl apply -f -
'''
          }

        }

      }
    }

  }
}