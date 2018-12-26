pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'squish --uglify'
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
    }
}