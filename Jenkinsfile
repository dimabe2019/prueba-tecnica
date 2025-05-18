pipeline {
    agent any

    enviroment {
        KARATE_ENV = 'qa' //o el que uses: dev, stagging, etc.
    }
    triggers {
        //Ejecuta el pipeline cuando haya un push al repo (requiere webhook en GitHub)
        githubPush()
    }

    tools {
        gradle 'Gradle 8.4'  //Asegurate que esta verwsion este configurada en Jenkins
        jdk 'OpenJDK 21.0.6' // Puede cambiarlo segun tu configuracion
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                git url: 'https://github.com/dimabe2019/prueba.tecnica.git', branch: 'main'
            }
        }

        stage('Compilar proyecto (sin test)') {
            steps {
                sh './gradlew build -x test'
            }
        }

        stage('Ejecutar pruebas Karate') {
            steps {
                sh './gradlew test -DKarate.env=${KARATE_ENV}'
            }
        }

        stage('Publicar reportes Karate') {
            steps {
                junit '**/build/test-result/test/*.xml'
                publishHTML([
                    reportDir: 'build/reports/karate',
                    reportFiles: 'karate-summary.html',
                    reportName: 'Reporte Karate'
                ])
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado'
        }
        success {
            echo 'Pipeline exitoso: pruebas pasaron correctamente'
        }
        failure {
            echo 'Fallo en el pipeline o las pruebas'
        }
    }
}