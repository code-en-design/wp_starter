# wp_starter

## composer.json  

To start a basic Wordpress website we use a few starterscripts.

- open terminal  and cd to the directory this script is in  
- mkdir *iamanartist* or something else...  
- change the iamanartist dir-name in composer.json (3 times)
- See https://wpackagist.org/ for more.
- run: composer install
- cd to wp directory (iamanartist) and copy wp-config-sample.php naar wp-config.php and fill in the dbase settings: 

    - cp wp-config-sample.php wp-config.php


- Prepare an empty database
- [https://api.wordpress.org/secret-key/1.1/salt/](https://api.wordpress.org/secret-key/1.1/salt/)
- change tableprefix in something less obvious then wp_  
- you can delete composer file  
- open the site, via mamp
- activate plugins 
- Fakerdata: [https://www.youtube.com/watch?v=sZu9lbTzUDY](https://www.youtube.com/watch?v=sZu9lbTzUDY)

## import_and_rename_dbase.sh
We use this script to import the database of a life Wordpress website into our development server.

## rename_and_export.sh
We use this script to export the database of a local Wordpress website for import into our live site.

see [https://wordpress.stackexchange.com/questions/290793/wp-cli-error-establishing-a-database-connection-in-localhost-mamp](https://wordpress.stackexchange.com/questions/290793/wp-cli-error-establishing-a-database-connection-in-localhost-mamp)

about: Make sure to use the MAMP PHP binary.

----

Feel free to use and change these scripts.  
Drop a note if you like!

---


### martin@code-en-design.nl
### https://github.com/code-en-design/wp_starter