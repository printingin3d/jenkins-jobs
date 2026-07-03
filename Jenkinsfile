pipeline{
    agent any
    triggers{ cron('H 4 * * *') }
    options {
        timeout(time: 2, unit: 'HOURS')   // timeout on whole pipeline job
    }
    stages {
        stage("backup Documents"){
            agent { label 'nas_agent' }
            steps{
                sh '''
                DOM=$(date +%d)   # Day of the month (01-31)
                DOW=$(date +%u)   # Day of the week (1-7, 1 is Monday)
    
                # 1. CREATE THE BACKUP WITH A SMART NAME
                if [ "$DOM" -eq 1 ]; then
                    # First day of the month: This is our permanent Monthly backup
                    FILENAME="documents_monthly_$(date +%Y%m)"
                elif [ "$DOW" -eq 7 ]; then
                    # It's Sunday: This is our Weekly backup
                    FILENAME="documents_weekly_$(date +%Y%W)"
                else
                    # Standard weekday: This is a Daily backup
                    FILENAME="documents_daily_$(date +%Y%m%d)"
                fi
                
                7z a -tzip -p"23Mirci_Hogolyo_Cirmi1" -mem=AES256 /data/backup/documents_backup/${FILENAME}.zip /data/documents/
                '''

                cleanWs()
            }
        }
        stage("backup HouseElf"){
    
            agent { label 'houseelf' }
    
            steps{
    
                sh '''
                DOM=$(date +%d)   # Day of the month (01-31)
                DOW=$(date +%u)   # Day of the week (1-7, 1 is Monday)
    
                # 1. CREATE THE BACKUP WITH A SMART NAME
                if [ "$DOM" -eq 1 ]; then
                    # First day of the month: This is our permanent Monthly backup
                    FILENAME="houseelf_monthly_$(date +%Y%m)"
                elif [ "$DOW" -eq 7 ]; then
                    # It's Sunday: This is our Weekly backup
                    FILENAME="houseelf_weekly_$(date +%Y%W)"
                else
                    # Standard weekday: This is a Daily backup
                    FILENAME="houseelf_daily_$(date +%Y%m%d)"
                fi
    
                rm -f houseelf*.tgz
                tar cfz ${FILENAME}.etc.tgz --ignore-failed-read /backups/host-etc/
                echo "put ${FILENAME}.etc.tgz /public/backup/houseelf_backup/" | sftp -P 9333 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/jenkins_agent_key server@192.168.0.165
    
                rm -f houseelf*.sql.gz
                mariadb-dump houseelf -h 192.168.0.100 --skip-ssl -u houseelf -ph0us33lf --compact --result-file=${FILENAME}.sql
                gzip --best ${FILENAME}.sql
                echo "put ${FILENAME}.sql.gz /public/backup/houseelf_backup/" | sftp -P 9333 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/jenkins_agent_key server@192.168.0.165
    
                ssh -p 9222 -o StrictHostKeyChecking=no -i /home/jenkins/.ssh/pruning_key ivivan@192.168.0.165
                '''

                cleanWs()
            }
        }
    }
}