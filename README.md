# Dockerized CFP #

## Purpose ##

Purpose of this repository is to provide a simple way to start docker container
for hosting cfp application.

## Set up ##

Prior to anything, you will have several thing to do in order to make it work :

* Bootstrap git submodule by executing the `bootstrap.sh` script

* You will need to create an `application-<env>.conf` file somewhere, in a git repository (based on the `cfp-devoxx-fr/conf/appliation-please-customize-me.conf` file)
  For instance, I created a dedicated branch on the `cfp-devoxx-fr` repository with cfp configuration files. See [configurations branch](https://gitlab.com/bdxio/cfp-bdx-io/tree/configurations). 
  You can follow this principle, or extract your configuration files in a dedicated repository.
  Note that you have an utility bash function declared in `cfp-src/source.sh` allowing to provision a given `application.conf` given an environment :
  `extractApplicationConfig prod`

* You will have to do the same as above for a `redis-config-<env>.conf` (based on the `cfp-devoxxfr-dockerized/redis/redis-config.conf` file)

* Then edit the `run-containers.sh` file and edit the `APP_CONFIG_REPO` variable with your repo
  Do ths same with the `create-containers.sh` file and the `REDIS_CONFIG_REPO` variable


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
