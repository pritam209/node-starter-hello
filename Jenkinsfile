pipeline {
    agent any
    
    tools {
        nodejs 'Latest node'  // Ensure this matches the name in Global Tool Configuration
    }

    environment {
        REMOTE_HOST = 'ubuntu@13.201.95.100'
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

                    # Run deployment commands on remote EC2
                    ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} << EOF
                    # Ensure NVM is sourced and Node.js is available
                    export NVM_DIR="$HOME/.nvm"
                    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
                    
                    . "$NVM_DIR/nvm.sh"  # This loads nvm
                    nvm install node
                    nvm use node
                    node -v 
                    sudo npm install -g pm2
                    cd /home/ubuntu/
                    pm2 stop my-app || true
                    pm2 start dist/main.js --name my-app
                    pm2 save
                    exit
                    EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            mail to: 'robinhooda66@gmail.com,xdankitjain@gmail.com,pallavisnaikdigital@gmail.com',
                 subject: "Build Success: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "The build ${env.JOB_NAME} ${env.BUILD_NUMBER} was successful."
        }
        failure {
            mail to: 'robinhooda66@gmail.com',
                 subject: "Build Failure: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "The build ${env.JOB_NAME} ${env.BUILD_NUMBER} failed."
        }
    }
}
