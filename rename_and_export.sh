#!/bin/bash

# martin@code-en-design.nl
# https://github.com/code-en-design/wp_starter

# We use this script to export the database of a local Wordpress website for import into our live site.

# we will need WP-CLI https://wp-cli.org/

# ---------> start here <---------------
# 1. Your dbase should be on you local comp
# 2. in bash: cd to the directory of this file
    # first use:
    # sudo chmod 700 rename_and_export.sh
# 3. set SEARCH and REPLACE (local domain/live domain), see below
# 4. set WPDIR to the directoryname where wp is is (where wp-config.php file is in), see below
# 5. set the admin adres in SEARCHADMINMAIL and REPLACEADMINMAIL, see below
# 6. run 

# ./rename_and_export.sh

# 7. answer some questions in the bash

# edit these:
SEARCH=https://slim3.slimzoeken.test
REPLACE=https://slim3.slimzoeken.nu
WPDIR=slim3wp

exportpath=/Users/martintakken/Desktop
# stop editing --------------------------



# start running! ------------------------
clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


HOMEPATH=$DIR/$WPDIR
cd $HOMEPATH

prefix=`wp config get table_prefix`
database=`wp config get DB_NAME`
user=`wp config get DB_USER`
password=`wp config get DB_PASSWORD`
host=`wp config get DB_HOST`
charset=`wp config get DB_CHARSET`

database_export=$database'_export'

d=`date +%Y-%m-%d`



# question 1 
printf '
------------------------------------------------------------------------------------------------
We will use the database from our development envirement (dbase: '$database' ).
We will do the search and replace and then we will export it as .gz file.


'


# get existing dbase for backup
mysqldump -u "$user"  -p$password $database | gzip > $exportpath"/"$database"_backup_"$d".sql.gz"

# now we can search and replace
printf '

------------------------------------------------------------------------------------------------
we replace the domainname...


'
wp search-replace $SEARCH $REPLACE  --recurse-objects --all-tables-with-prefix --export=$exportpath/$database_export.sql
gzip -f $exportpath/$database_export.sql > $exportpath/$database_export.sql.gz

echo klaar!

