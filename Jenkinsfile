

pipeline {
  agent any
  environment {
    PROJECT = "manhnd1408/bkacad"
    ENV = "test"
  }

  stages {
    
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
    stage('Update Helm Charts') { 
      steps {
        script {
//           sh "git clone https://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@github.com/manh148/simplehelm.git"
          env.COMMIT_HASH = sh(script:'git rev-parse --short=8 HEAD', returnStdout: true).trim()
//           sh 'cd simplehelm'
          sh 'sed -i "s/bkacad.*/bkacad:${COMMIT_HASH}/g" /var/lib/jenkins/simplehelm/simplehelm/values.yaml'
          sh 'cd simplehelm && git add . && git commit -m "update new version"'
          sh 'cd simplehelm && git push'
        }
      }
    }
  }
}
