docker-nodebb
===========

This docker image provide a nodebb forum, with silent install and smtp relay enabled with ssmtp.

## How to use : 
### With docker-compose (full stack with mongodb) :
Edit nodebb.env and specify your environnement (empty fields are optional). If you change the port of nodebb, edit docker-compose.yml too.
Run with : 
```
sudo docker-compose up
```

### With docker run : 
If you already have a mongo db instance running, edit nodebb.env and run with :
```
sudo docker run --env-file=./nodebb.env -ti digitallumberjack/docker-nodebb:latest
```
