pipeline {
  agent any

  environment {
    IMAGE_NAME = "space4u_app_local"    // local image name (not pushed)
    CONTAINER_SERVICE = "web1"           // service name in docker-compose (if used)
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          // get short commit hash for tagging
          SHORT_COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = "${IMAGE_NAME}:${SHORT_COMMIT}"
          echo "Image tag will be ${env.IMAGE_TAG}"
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "Building Docker image ${env.IMAGE_TAG}..."
        sh "docker build -t ${env.IMAGE_TAG} ."
      }
    }

    stage('Stop old containers') {
      steps {
        echo "Stopping old containers (if any)..."
        // if you use docker-compose service name, adjust below
        sh '''
          if docker ps -q -f name=space4u_app; then
            docker-compose down || true
          fi
        '''
      }
    }

    stage('Start new containers') {
      steps {
        echo "Starting containers with docker-compose..."
        // docker-compose will rebuild images referenced in compose if needed,
        // but we use --build to be safe
        sh "docker-compose up -d --build"
      }
    }

    stage('Post-check') {
      steps {
        echo "List running containers:"
        sh "docker ps --filter ancestor=${env.IMAGE_TAG} --format 'table {{.ID}}\\t{{.Image}}\\t{{.Names}}\\t{{.Status}}' || true"
      }
    }
  }

  post {
    success {
      echo "Deployment successful: ${env.IMAGE_TAG}"
    }
    failure {
      echo "Deployment failed. Check console output."
    }
  }
}
