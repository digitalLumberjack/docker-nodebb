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

### Environment variables : 
* NODEBB_URL=http://www.example.com (the front url for nodebb)
* NODEBB_PORT=4567 (the port to bind)
* NODEBB_SECRET=ubersecretkey (the secret for password, should be the same on different containers for the same nodebb instance)
* NODEBB_PLUGINLIST=nodebb-plugin-s3-uploads-updated@0.3.10 (the list of plugins to install at startup, separated by a space, optional)
* MONGO_HOST=mongo (ip or hostname of mongo master, separated by "," for replica)
* MONGO_PORT=27017 (port of mongo master, separated by "," for replica)
* MONGO_USERNAME= (optional)
* MONGO_PASSWORD= (optional)
* MONGO_DATABASE= (optional)
* ADMIN_USERNAME=admin (nodebb administrator username for login)
* ADMIN_PASSWORD=adminsupersecure (nodebb administrator password for login)
* ADMIN_EMAIL=admin@example.com
* SSMTP_DOMAIN=example.com (domain for smtp configuration)
* SSMTP_EMAIL=forum@example.com (sender email for notifications)
* SSMTP_HOST=mail.example.com (smtp host)
* SSMTP_PORT=587 (smtp port)
* SSMTP_PASSWORD=ubersupasecure (smtp password)
* AWS_ACCESS_KEY_ID= (amazon S3 access key id, optional)
* AWS_SECRET_ACCESS_KEY= (amazon S3 secret access key, optional)
* S3_UPLOADS_BUCKET= (amazon S3 bucket name, optional)
* S3_UPLOADS_HOST= (amazon S3 bucket url, e.g. : forums.example.com.s3-website-eu-west-1.amazonaws.com)

