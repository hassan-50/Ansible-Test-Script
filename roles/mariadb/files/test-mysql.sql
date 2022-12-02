-- Create First Database:
create database ums;

--  Create Second Database:
create database wr;

-- Enter the following command to create a user named aviancloud with password password:
GRANT USAGE ON *.* TO 'aviancloud'@'localhost' IDENTIFIED BY 'password';

-- Grant the nuix user the following required privileges within the ums database:
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON ums.* TO 'aviancloud'@'localhost';

-- Grant the nuix user all required privileges within the wr database:
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON wr.* TO 'aviancloud'@'localhost';

-- For the changes to take effect, flush the privileges:
FLUSH PRIVILEGES;
