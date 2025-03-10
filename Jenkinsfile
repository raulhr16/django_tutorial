pipeline {
    environment {
        IMAGEN = "raulhr16/django_tutorial"
        USUARIO = 'docker'
    }
    agent none
    stages {
        stage("Comprobacion del proyecto") {
            agent {
                docker { image 'python:3'
                args '-u root:root'
                }
            }
            stages {
                stage('Clonando') {
                steps {
                    git branch:'master',url:'https://github.com/raulhr16/django_tutorial'
                    }
                }
                stage('Instalando') {
                steps {
                    sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                steps {
                    sh 'python3 manage.py test'
                    }
                }
            }
        }
        stage("Creación de la imagen docker") {
            agent any
            stages {
                stage('Clonando') {
                steps {
                    git branch:'master',url:'https://github.com/raulhr16/django_tutorial'
                    }
                }
                stage('Build') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:$BUILD_NUMBER"
                        }
                    }
                }
                stage('Deploy') {
                    steps {
                        script {
                            docker.withRegistry( '', USUARIO ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Clean Up') {
                    steps {
                        sh "docker rmi $IMAGEN:$BUILD_NUMBER"
                        }
                }
            }
        }
    }
}
