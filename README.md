# Dockerized CFP #

## Purpose ##

Purpose of this repository is to provide a simple way to start docker container
for hosting cfp application.

## Set up ##

Prior to anything, you will have several thing to do in order to make it work :

* You will need to create an `application-<env>.conf` file somewhere, in a git repository
  For instance, I created a dedicated branch on the `cfp-devoxx-fr` repository with cfp configuration files. See [configurations branch](https://bitbucket.org/bdxio/cfp-devoxx-fr/src/HEAD/?at=configurations). 
  You can follow this principle, or extract your configuration files in a dedicated repository.

* Then edit the `run-containers` file and edit the `APP_CONFIG_REPO` variable with your repo


Once done, you will need to :

* Run the `create-containers.sh` bash script once to create the 3 needed docker images (elastic search, redis and the webapp)

* Once done, run the `run-containers.sh <env>` to start previously created docker images, passing <env> as a parameter (the env will be used to retrieve the good `application.conf` file as described above)


Side note : if you forked the `cfp-devoxx-fr` repository, don't hesitate to change cfp-src/ git submodule in order to target your own repository.
For this :
```
git submodule deinit cfp-src
git rm cfp-src
git submodule add cfp-src <your git repository>
```