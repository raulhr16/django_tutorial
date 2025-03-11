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
                    sh 'python3 manage.py test --settings=django_tutorial.settings_des'
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
        stage ('Despliegue') {
            agent any
            stages {
                stage ('Deploy en el VPS'){
                    steps{
                        sshagent(credentials : ['vps']) {
                            sh """
                                ssh -o StrictHostKeyChecking=no debian@vps.raulhr.site "
                                cd django_tutorial &&
				git pull &&
				sed -i 's|^imagen_app=.*|imagen_app=raulhr16/django_tutorial:23|' .env &&
                                docker-compose down -v &&
                                docker pull "$IMAGEN:$BUILD_NUMBER" &&
                                docker-compose up -d &&
                                docker image prune -f"
                            """
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            emailext(
                to: 'alertas.snort.raulhr@gmail.com',
                subject: "Pipeline IC: ${currentBuild.fullDisplayName}",
                body: "${env.BUILD_URL} ha terminado con estado ${currentBuild.result}"
            )
        }
    }
}
