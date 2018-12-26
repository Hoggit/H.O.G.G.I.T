pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '/opt/squish/bin/squish --no-minify'
<<<<<<< HEAD
                sh 'ldoc {env.WORKSPACE}'
            }
        }
       /* stage('Deploy') {
            when {
                branch 'production'
            }

            steps {

            }
        }*/
=======
                sh "ldoc ${env.WORKSPACE}"
            }
        }
       stage('Deploy') {
            when {
                tag 'release-*'
            }

            steps {
                sh "python3 /opt/hoggit_releaser/releaser.py ${env.WORKSPACE} ${env.TAG_NAME}"
            }
        }
>>>>>>> feature/Jenkinsfile
    }
}