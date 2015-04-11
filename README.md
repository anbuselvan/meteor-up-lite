# Meteor Up Lite
#### Quick Linux Meteor Deployments as a non-privileged user (eg. ubuntu) with no ssl support (not recommended for production).

## Disclaimer
All credits should go to Arunoda and his team for his excellent contribution to the Meteor Community. This is a lite version of Meteor-Up (*mup*) and please feel free to share your comments, suggestions and issues on [github](https://github.com/anbuselvan/meteor-up-lite/issues). To prevent conflict with the original version the command will be *mupl*, so you can install and use both versions.

#### Prerequisite
Follow the steps from 'Additional Resources' section to pre-install Nginx before using *mupl* to configure and start the web server using port 80.

Your meteor app will be deployed in the following path:
*/home/ubuntu/meteor/<your meteor app>*

### Setup

Please follow the setup instructions from [Meteor Up](https://github.com/arunoda/meteor-up), and ignore all the ssl related configurations.

### Example File

```js
{
  // Server authentication info
  "servers": [
    {
      "host": "hostname",
      "username": "ubuntu",
      "password": "password"
      // or pem file (ssh based authentication)
      // WARNING: Keys protected by a passphrase are not supported
      //"pem": "~/.ssh/id_rsa"
      // server specific environment variables
      "env": {}
    }
  ],

  // Install MongoDB on the server. Does not destroy the local MongoDB on future setups
  "setupMongo": true,

  // WARNING: Node.js is required! Only skip if you already have Node.js installed on server.
  "setupNode": true,

  // WARNING: nodeVersion defaults to 0.10.36 if omitted. Do not use v, just the version number.
  "nodeVersion": "0.10.36",

  // Install PhantomJS on the server
  "setupPhantom": true,

  // Application name (no spaces).
  "appName": "myapp",

  // Location of app (local directory). This can reference '~' as the users home directory.
  // i.e., "app": "~/Meteor/myapp",
  // This is the same as the line below.
  "app": "/Users/username/Meteor/myapp",

  // Configure environment
  // UPSTART_UID must be set
  "env": {
    "PORT": 3000,
    "ROOT_URL": "http://myapp.com",
    "MONGO_URL": "mongodb://localhost:27017/MyApp",
    "MAIL_URL": "smtp://postmaster%40myapp.mailgun.org:user@smtp.mailgun.org:587/"
  },

  // Meteor Up Lite checks if the app comes online just after the deployment.
  // Before mupl checks that, it will wait for the number of seconds configured below.
  "deployCheckWaitTime": 15
}
```

### Additional Resources

* [Using Meteor Up Lite with NginX vhosts](https://github.com/arunoda/meteor-up/wiki/Using-Meteor-Up-with-NginX-vhosts)
