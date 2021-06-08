docker network create is.matas.dk --subnet=172.19.0.0/16
--
docker stop dev-db
docker rm dev-db

--

docker run -p 1433:1433 --name dev-db --network is.matas.dk -e ACCEPT_EULA=Y -e SA_PASSWORD=R1o2o3t4 -d mcr.microsoft.com/mssql/server:2019-latest
sleep 5

docker exec dev-db mkdir usr/dbscripts
docker cp ~/work/wso2/matas/git/ansible-is-master/files/dbscripts/5.11.0/mssql.sql dev-db:usr/dbscripts/shared.sql
docker cp ~/work/wso2/matas/git/ansible-is-master/files/dbscripts/5.11.0/bps/bpel/create/mssql.sql dev-db:usr/dbscripts/bps.sql
docker cp ~/work/wso2/matas/git/ansible-is-master/files/dbscripts/5.11.0/identity/mssql.sql dev-db:usr/dbscripts/identity.sql
docker cp ~/work/wso2/matas/git/ansible-is-master/files/dbscripts/5.11.0/consent/mssql.sql dev-db:usr/dbscripts/consent.sql
sleep 5

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE DATABASE WSO2SHARED_DB"
sleep 2

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE DATABASE WSO2CONSENT_DB"
sleep 2

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE DATABASE WSO2IDENTITY_DB"
sleep 2

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE DATABASE WSO2BPS_DB"
sleep 2

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE DATABASE MATAS"
sleep 2

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE LOGIN wso2_shared_user WITH PASSWORD='jfewWER#6few'"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE LOGIN wso2_consent_user WITH PASSWORD='jfewWER#6few'"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE LOGIN wso2_identity_user WITH PASSWORD='jfewWER#6few'"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "CREATE LOGIN wso2_bps_user WITH PASSWORD='jfewWER#6few'"

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "USE WSO2SHARED_DB; CREATE USER wso2_shared_user for LOGIN wso2_shared_user; GRANT CONTROL ON SCHEMA::dbo TO wso2_shared_user; GRANT CONTROL ON DATABASE::WSO2SHARED_DB TO wso2_shared_user;"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "USE MATAS; CREATE USER wso2_shared_user for LOGIN wso2_shared_user; GRANT CONTROL ON SCHEMA::dbo TO wso2_shared_user; GRANT CONTROL ON DATABASE::MATAS TO wso2_shared_user;"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "USE WSO2CONSENT_DB; CREATE USER wso2_consent_user for LOGIN wso2_consent_user; GRANT CONTROL ON SCHEMA::dbo TO wso2_consent_user; GRANT CONTROL ON DATABASE::WSO2CONSENT_DB TO wso2_consent_user;"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "USE WSO2IDENTITY_DB; CREATE USER wso2_identity_user for LOGIN wso2_identity_user; GRANT CONTROL ON SCHEMA::dbo TO wso2_identity_user; GRANT CONTROL ON DATABASE::WSO2IDENTITY_DB TO wso2_identity_user;"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P R1o2o3t4 -Q "USE WSO2BPS_DB; CREATE USER wso2_bps_user for LOGIN wso2_bps_user; GRANT CONTROL ON SCHEMA::dbo TO wso2_bps_user; GRANT CONTROL ON DATABASE::WSO2BPS_DB TO wso2_bps_user;"

docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U wso2_shared_user -P jfewWER#6few -d WSO2SHARED_DB -i "usr/dbscripts/shared.sql"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U wso2_bps_user -P jfewWER#6few -d WSO2BPS_DB -i "usr/dbscripts/bps.sql"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U wso2_consent_user -P jfewWER#6few -d WSO2CONSENT_DB -i "usr/dbscripts/consent.sql"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U wso2_identity_user -P jfewWER#6few -d WSO2IDENTITY_DB -i "usr/dbscripts/identity.sql"
docker exec dev-db /opt/mssql-tools/bin/sqlcmd -S localhost -U wso2_shared_user -P jfewWER#6few -d MATAS -i "usr/dbscripts/shared.sql"



