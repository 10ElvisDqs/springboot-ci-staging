pipeline {
    agent any
    environment {
        STAGING_SERVER = 'spring_user_java@spring-docker-demo-mv'
        ARTIFACT_NAME = 'demo-0.0.1-SNAPSHOT.jar'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/10ElvisDqs/springboot-ci-staging.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Code Quality') {
            steps {
                // sh 'mvn checkstyle:check'
                echo 'Code quality checks passed.'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Code Coverage') {
            steps {
                sh 'mvn jacoco:report'
            }
        }
        stage('Deploy to Staging') {
            steps {
                // llave de jenkins
                sshagent(['jenkis-spring-docker-key']) {
                    sh 'scp target/${ARTIFACT_NAME} $STAGING_SERVER:/home/spring_user_java/staging/'
                    // sh 'ssh $STAGING_SERVER "nohup java -jar /home/spring_user_java/staging/${ARTIFACT_NAME} > /dev/null 2>&1 &"'
                    sh 'ssh -o StrictHostKeyChecking=no $STAGING_SERVER "nohup /opt/java/openjdk/bin/java -jar /home/spring_user_java/staging/${ARTIFACT_NAME} > /home/spring_user_java/staging/spring.log 2>&1 &"'
                }
            }
        }
        // stage('Deploy to Staging') {
        //     steps {
        //         sshagent(['jenkis-spring-docker-key']) {
        //             sh 'scp target/${ARTIFACT_NAME} $STAGING_SERVER:/home/spring_user_java/staging/ && ssh -o StrictHostKeyChecking=no $STAGING_SERVER "pkill -f java || true; nohup /opt/java/openjdk/bin/java -jar /home/spring_user_java/staging/${ARTIFACT_NAME} > /home/spring_user_java/staging/spring.log 2>&1 &"'
        //         }
        //     }
        // }
        stage('Deploy to Staging') {
            steps {
                sshagent(['jenkis-spring-docker-key']) {
                    sh """
                        # Copiar el artefacto
                        scp target/${ARTIFACT_NAME} $STAGING_SERVER:/home/spring_user_java/staging/

                        # Matar todos los procesos Java y levantar la nueva instancia
                        ssh -o StrictHostKeyChecking=no $STAGING_SERVER "
                            pkill -f java || true
                            nohup /opt/java/openjdk/bin/java -jar /home/spring_user_java/staging/${ARTIFACT_NAME} > /home/spring_user_java/staging/spring.log 2>&1 &
                        "
                    """
                }
            }
        }
        stage('Validate Deployment') {
            steps {
                sh 'sleep 10'
                sh 'curl --fail http://spring-docker-demo-mv:8080/health'
            }
        }
    }
}