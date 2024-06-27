pipeline {
    agent any
    
    tools {
        nodejs 'Latest node'  // Ensure this matches the name in Global Tool Configuration
    }

    environment {
        REMOTE_HOST = 'ubuntu@35.154.199.120'
        SSH_CREDENTIALS_ID = 'jenkins_slave'  // Update with the credentials ID from Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/NikhilChowdhury27/node-starter.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy to Remote EC2') {
            steps {
                sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
                    sh '''
                    # Copy build artifacts to remote EC2
                    scp -o StrictHostKeyChecking=no -r dist/ ${REMOTE_HOST}:/home/ubuntu/

                    # Copy deployment script to remote EC2
                    scp -o StrictHostKeyChecking=no deploy.sh ${REMOTE_HOST}:/home/ubuntu/

                    # Run deployment script on remote EC2
                    ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} << EOF
                    chmod +x /home/ubuntu/deploy.sh
                    /home/ubuntu/deploy.sh

                    exit
                    EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            emailext(
                to: 'nikhilchowdhury666@gmail.com',
                subject: "Build Success: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                body: """
                <html>
                <body>
                    <h2>Build Success</h2>
                    <p>The build <strong>${env.JOB_NAME} ${env.BUILD_NUMBER}</strong> was successful.</p>
                    <p><a href="${env.BUILD_URL}">View Build Details</a></p>
                    <p>Thank you,</p>
                    <p>Jenkins CI</p>
                </body>
                </html>
                """,
                mimeType: 'text/html'
            )
        }
        failure {
            emailext(
                to: 'nikhilchowdhury666@gmail.com',
                subject: "Build Failure: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                body: """
                <html>
                <body>
                    <h2>Build Failure</h2>
                    <p>The build <strong>${env.JOB_NAME} ${env.BUILD_NUMBER}</strong> failed.</p>
                    <p><a href="${env.BUILD_URL}">View Build Details</a></p>
                    <p>Thank you,</p>
                    <p>Jenkins CI</p>
                </body>
                </html>
                """,
                mimeType: 'text/html'
            )
        }
    }
}
