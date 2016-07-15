# Dockerized CFP #

## Purpose ##

Purpose of this repository is to provide a simple way to start docker container
for hosting cfp application.

## Set up ##

Prior to anything, you will have several thing to do in order to make it work :

* Bootstrap directories & git submodule by executing the `bootstrap.sh` script

* You will need to create an `application-<env>.conf` file somewhere, in a git repository (based on the `cfp-devoxx-fr/conf/appliation-please-customize-me.conf` file)
  For instance, I created a dedicated branch on the `cfp-devoxx-fr` repository with cfp configuration files. See [configurations branch](https://gitlab.com/bdxio/cfp-bdx-io/tree/configurations). 
  You can follow this principle, or extract your configuration files in a dedicated repository.
  Note that you have an utility bash function declared in `cfp-src-*/source.sh` allowing to provision a given `application.conf` given an environment :
  `extractApplicationConfig prod`

* You will have to do the same as above for a `redis-config-<env>.conf` (based on the `cfp-devoxxfr-dockerized/redis/redis-config.conf` file)

* Run `docker-compose up -d` in order to build & run every declared services into docker-compose.yml file
  Run `docker logs -f $(docker ps -f name=cfp-prod | cut -d' ' -f1)`©and wait for the cfp play2 webapp to completely be started.
  For this, you need to see something like `play: Application started`
  Once done, restart the `letsencrypt-nginx-proxy-companion` in order to generate let's encrypt certificates : `docker restart $(docker ps -f name=letsencrypt-nginx-proxy-companion | cut -d' ' 
-f1)` and look at its log to be sure both testing & prod certificates are generated correctly.

* Once done, you will need to manually link dropbox docker instance container with your own dropbox account
  For this, you will need to retrieve dropbox token url generated inside the dropbox docker instance : `docker logs -f cfpbdxiodockerized_dropbox_1`
  And then, connect to your dropbox account in a browser and copy/paste the logs' token url into it in order to initiate dropbox sync of the backup folder


Side note : if you forked the `cfp-devoxx-fr` repository, don't hesitate to change cfp-src-*/ git submodules in order to target your own repository.
For this :
```
git submodule deinit cfp-src-prod
git rm cfp-src-prod
git submodule add cfp-src-prod <your git repository>
```

## Things to do when initializing a new Year  ##

To bootstrap a new year, you will have to change following things :
- Checkout `configurations` branch from this repository, and update `application-prod.conf`'s `mail.comittee.email` entry accordingly to a new google group for this year's event
  Then create a new google group dedicated to CFP voters (generally named cfp-bdxio-XXXX@googlegroups.com where XXXX is the target year).
  Configuration worth noting when creating this google group is to :
-- Group type : Mailing list
-- Displaying topics : group's members only
-- Publishing : Public (it is required in order to allow to send email to the google group folks)
-- Join the group : Invitation only
-- After creation, in Informations -> Directory, uncheck the "Declare this group in the directory" checkbox
-- After creation, in Parameters -> Email options, put an "Email object prefix" to something like "[CFP - bdx.io - 2016]"
- Update `ConferenceDescriptor.scala` on branch `dev` file with :
-- New dates
-- Potentially new rooms
-- Potentially new tracks
  You can have a look at [this commit](https://gitlab.com/bdxio/cfp-bdx-io/commit/86f899ef04d7451fb9fff3d4b4e25c29a90846ee) to see how to change this properly
- Once previous step is done, checkout `testing` branch and merge `dev` branch on it in order to include these changes into it
- Execute the "Set Up" steps prior to the `docker-compose up -d` step
- Once the CFP is running, you will need to create admin accounts
  To do so, you will first need to create a standard accound, then call the `GET http://<cfp-url>/admin/bootstrapAdminUser` which will check there isn't any administrator yet, and will
  then promote current user to the admins groups.
  To add more administrators, you will need to retrieve user id you want to promote (go to user details screen through Backoffice for instance), and then call
  `GET http://<cfp-url>/admin/promoteToAdminUser?uuid=<uuid>` as a user administrator.


## Things to follow when restoring a redis backup ##

Follow these instructions, it's working : http://stackoverflow.com/a/23233940/476345
