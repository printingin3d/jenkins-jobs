pipeline{
    agent { label 'houseelf' }
    options {
        timeout(time: 2, unit: 'HOURS')   // timeout on whole pipeline job
    }
    stages {
        stage("MySQL Dump + Gzip"){
            steps{
                sh '''rm -f houseelf.etc.*.tgz
                tar cfz houseelf.etc.${BUILD_TIMESTAMP}.tgz --ignore-failed-read /backups/host-etc/
                echo "put houseelf.etc.${BUILD_TIMESTAMP}.tgz /public/backup/houseelf_backup/" | sftp -P 9333 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/jenkins_agent_key server@192.168.0.165
                '''
                
                cleanWs()
            }
        }
    }
}