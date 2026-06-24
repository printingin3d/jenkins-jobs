pipeline{
    agent { label 'houseelf' }
    options {
        timeout(time: 2, unit: 'HOURS')   // timeout on whole pipeline job
    }
    stages {
        stage("tar + Gzip /etc"){
            steps{
                sh '''rm -f houseelf.etc.*.tgz
                tar cfz houseelf.etc.${BUILD_TIMESTAMP}.tgz --ignore-failed-read /backups/host-etc/
                echo "put houseelf.etc.${BUILD_TIMESTAMP}.tgz /public/backup/houseelf_backup/" | sftp -P 9333 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/jenkins_agent_key server@192.168.0.165
                '''
                
                cleanWs()
            }
        }
        stage("MySQL Dump + Gzip"){
            steps{
                sh '''rm -f houseelf.*.sql.gz
                mariadb-dump houseelf -h 192.168.0.100 --skip-ssl -u houseelf -ph0us33lf --compact --result-file=houseelf.${BUILD_TIMESTAMP}.sql
                gzip --best houseelf.${BUILD_TIMESTAMP}.sql
                echo "put houseelf.${BUILD_TIMESTAMP}.sql.gz /public/backup/houseelf_backup/" | sftp -P 9333 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/jenkins_agent_key server@192.168.0.165
                '''

                cleanWs()
            }
        }
    }
}