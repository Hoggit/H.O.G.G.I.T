pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '/opt/squish/bin/squish --no-minify'
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
    }
}