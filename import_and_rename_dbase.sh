#!/bin/bash

# martin@code-en-design.nl
# https://github.com/code-en-design/wp_starter

# We use this script to import the database of a life Wordpress website into our development server.

# we will need WP-CLI https://wp-cli.org/

# ---------> start here <---------------
# 1. put your dbase zip or gzip file (i use the updraftplus output) on your desktop
# 2. in bash: cd to the directory of this file
    # first use:
    # sudo chmod 700 import_and_rename_dbase.sh
# 3. set SEARCH and REPLACE (old domain/new or local domain), see below
# 4. set WPDIR to the directoryname where wp is is (where wp-config.php file is in), see below
# 5. set the admin adres in SEARCHADMINMAIL and REPLACEADMINMAIL, see below
# 6. run ./import_and_rename_dbase.sh
# 7. answer some questions in the bash

# edit these:
SEARCH=http://lifedomain.com
REPLACE=http://testdomain.com
WPDIR=iamanartist
SEARCHADMINMAIL=webadmin@lifedomain.com
REPLACEADMINMAIL=martin@testdomain.com
# stop editing --------------------------










# start running! ------------------------
clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
printf '
------------------------------------------------------------------------------------------------
We are in '$DIR'


'

HOMEPATH=$DIR/$WPDIR
cd $HOMEPATH

prefix=`wp config get table_prefix`
database=`wp config get DB_NAME`
user=`wp config get DB_USER`
password=`wp config get DB_PASSWORD`
host=`wp config get DB_HOST`
charset=`wp config get DB_CHARSET`

# question 1 
printf '


------------------------------------------------------------------------------------------------
Database import from gz file 
----------------------------
We will import the database to our development envirement (dbase: '$database' ).
Use the .gz file that should be on your desktop, these are the files starting with backup (updraft):


'

cd ~/Desktop
ls -la backup*

printf '

Copy/paste the name of the database-backupfile (backup_xxxx-xx-xx-xxxx_lifesite_xxxxxxxxx-db.gz):

'
read dbaseexportfile

clear
# question 2
printf '


------------------------------------------------------------------------------------------------
We can also anonimize userdata (we will skip the user with id nr 1).

scramble data? y/n


'
read scramble

# go!
clear

printf '


------------------------------------------------------------------------------------------------
We import the .gz file...

'


# https://stackoverflow.com/questions/20751352/suppress-warning-messages-using-mysql-from-within-terminal-but-password-written
# mysql_config_editor set --login-path=local --host=$host --user=$user --password

# mysql globals
# mysql complains about security here but we just ignore...
# mysql: [Warning] Using a password on the command line interface can be insecure.

# to suppress this warninh it's also possible to skip the -p$password everywhere, and use:
# mysql password in my.cnf:
# nano .my.cnf
# [mysql]
# user=mysqluser
# password=mysqlpass

mysql --user="$user" -p$password --database="$database" --execute="SET @@GLOBAL.sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'"
zcat < ~/Desktop/$dbaseexportfile | mysql -u 'root' -p$password $database
cd $HOMEPATH

printf '

------------------------------------------------------------------------------------------------
we replace the domainname...


'
wp search-replace $SEARCH $REPLACE  --recurse-objects --all-tables-with-prefix



printf '

------------------------------------------------------------------------------------------------
we replace the admin mailaddress...


'
wp search-replace $SEARCHADMINMAIL $REPLACEADMINMAIL --recurse-objects --all-tables-with-prefix



if [ "$scramble" = "y" ]; then

    echo scramble...

    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"users set user_login = concat(ID,'_login'), user_email = concat(ID,'_user@mailthatdoesnotexist.com'), user_nicename = concat(ID,'-nicename'), user_activation_key = '', display_name = concat(ID,'_display') where ID > '1';"

    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('Nickname-',user_id) where meta_key='nickname' and user_id > '1';"
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('Firstname',user_id) where meta_key='first_name' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('Lastname',user_id) where meta_key='last_name' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('straatnaam ',user_id) where meta_key='addr1' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('02123456789') where meta_key='phone1' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('NL11INGB0003444455') where meta_key='iban' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('1234567898765432') where meta_key='EAN' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('U.I.') where meta_key='initials' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('de la') where meta_key='tussenvoegsel' and meta_value !='' and user_id > '1';";
    mysql --user="$user" -p$password --database="$database" --execute="update "$prefix"usermeta set meta_value = concat('Bedrijfsnaam',user_id) where meta_key='Bedrijfsnaam' and meta_value !='' and user_id > '1';";

fi

echo klaar!

open -a "Google Chrome" $REPLACE