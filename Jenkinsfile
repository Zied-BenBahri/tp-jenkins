pipeline {
  agent any

  environment {
    DOCKER_HUB_REPO = 'ziedbenbahri/dockerapp'
    DOCKER_CREDENTIALS = 'dockerhub-creds'
  }

  tools {
    maven 'Maven_3_9'
  }

  stages {
    stage('Checkout') {
      steps {
        echo '🔹 Clonage du dépôt Git...'
        git branch: 'main', url: 'https://github.com/Zied-BenBahri/tp-jenkins.git'
      }
    }

    stage('Build with Maven') {
      steps {
        echo '🔹 Construction du projet Maven...'
        // exécution à la racine (pas dans /dockerapp)
        sh 'mvn -f pom.xml clean package -DskipTests'
      }
    }

    stage('Run Tests') {
      steps {
        echo '🔹 Exécution des tests...'
        sh 'mvn test'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo '🔹 Construction de l’image Docker...'
        script {
          def dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        echo '🔹 Publication de l’image sur Docker Hub...'
        script {
          docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS}") {
            def dockerImage = docker.image("${DOCKER_HUB_REPO}:latest")
            dockerImage.push()
          }
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline terminé — image publiée sur Docker Hub.'
    }
    failure {
      echo '❌ Le pipeline a échoué. Consultez les logs Jenkins pour les détails.'
    }
  }
}