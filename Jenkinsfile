

pipeline {
  agent any
  environment {
    PROJECT = "manhnd1408/bkacad"
    ENV = "test"
  }

  stages {
    stage ('Demo build Docker') {
      agent {
        docker {
            image 'alpine'
        }
      }
      steps {
        script {
        sh 'touch DEMODOCKERBUILD.txt' 
        sh 'sleep 30'
        sh "echo Test Docker Build > DEMODOCKERBUILD.txt"
        }
        stash includes: '**/DEMODOCKERBUILD.txt', name: 'results' 
      }
    }
    
    stage('Pre Build') { 
      steps {
        script {
        sh 'echo Prebuild command'
        sh 'echo Logging in to Images Registry'
        sh "cat /opt/docker_token.txt | docker login --username manhnd1408 --password-stdin"
        }
      }
    }
    stage('Build') { 
      steps {
        unstash 'results'
        script {
        sh 'echo Start build ...'
        env.COMMIT_HASH = sh(script:'git rev-parse --short=8 HEAD', returnStdout: true).trim()
        sh 'echo $COMMIT_HASH'
        sh 'echo Building the Docker image...'
        sh 'docker build -t $PROJECT:latest .'
        sh 'docker tag ${PROJECT}:latest ${PROJECT}:$COMMIT_HASH'
        sh 'echo Build completed on `date`'
        sh 'echo Pushing the Docker image...'
        sh "docker push ${PROJECT}:latest"
        sh "docker push ${PROJECT}:$COMMIT_HASH"   
        }
      }
    }
//     stage('Deploy') { 
//       steps {
//         script {
//           sh 'rm -rf /opt/cicd/chainprotocol-infrastructure'
//           sh "git clone https://${GIT_PAT}@github.com/Bsincent/chainprotocol-infrastructure.git /opt/cicd/chainprotocol-infrastructure"
//           env.COMMIT_HASH = sh(script:'git rev-parse --short=8 HEAD', returnStdout: true).trim()
//           sh 'sed -i "s/chainptc-dev-apikey.*/chainptc-dev-apikey:${COMMIT_HASH}/g" /opt/cicd/chainprotocol-infrastructure/helm/fullnode-chainprotocol-apikey/values.yaml'
//           sh 'ansible-playbook /opt/cicd/chainptc-fullnode-apikey.yaml'
//         }
//       }
//     }
  }
}
