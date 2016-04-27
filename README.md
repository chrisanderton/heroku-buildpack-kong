*Deprecated:* Use [this instead](https://github.com/heroku/heroku-buildpack-kong)

# heroku-buildpack-kong

Experimental buildpack for running Kong on Heroku. **Do not use in Production**!

Currently assumes Instaclustr Starter plan.

Heroku apps can currently only bind to a single external port.

A default Procfile is created by the buildpack.

The API server is bound to the externally accessible port by default.

If a config variable named `KONG_ADMIN` is present the Admin server is bound to the externally accessible port.

You probably can't use DNS based discovery - you would need to use hostname based routing.

You will need to consider things like security (you don't want your admin exposed to the world) - and also perhaps trying to enforce HTTPS only. These are TODO items that may be possible with some additional Nginx configuration (or eventually use something like Heroku Private Spaces!)

##Example

Replace `api-app-name` and `admin-app-name` with your own unique names. You could use a single source repository and name the remotes per function - at the moment the app repository just needs 'something' in there to push and trigger the deploy.

###Setting up the API app
From your base directory of choice..

```
mkdir api-app-name
cd api-app-name
git init
heroku apps:create api-app-name
heroku addons:create instaclustr:starter
```

Wait for Instaclustr to be ready.. (check `heroku config` for the IC_* config variables to be populated)

```
heroku buildpacks:set https://github.com/chrisanderton/heroku-buildpack-kong
touch deploy && git add deploy && git commit -a -m "deploy"
git push heroku master
```

###Setting up the Admin app
Instaclustr doesn't support addon sharing - unfortunately it means we have to copy config variables from one app to the other - keep in mind that you will need to manually keep these in sync. We also set the `KONG_ADMIN` config variable.

From your base directory of choice..

```
mkdir admin-app-name
cd admin-app-name
git init
heroku apps:create admin-app-name
for cv in IC_CONTACT_POINTS IC_PORT IC_USER IC_PASSWORD; do heroku config:set `heroku config:get -s -a api-app-name $cv`; done
heroku config:set KONG_ADMIN=1
heroku buildpacks:set https://github.com/chrisanderton/heroku-buildpack-kong
touch deploy && git add deploy && git commit -a -m "deploy"
git push heroku master
```

###Test.. 
Follow the [tutorial](https://getkong.org/docs/0.5.x/getting-started/adding-your-api/) - the only difference is that instead of the admin running on a port it is running on a different hostname. Use the API app and admin app you created above.

```
curl -i -X POST \
  --url http://admin-app-name.herokuapp.com/apis/ \
  --data 'name=mockbin' \
  --data 'upstream_url=http://mockbin.com/' \
  --data 'request_host=mockbin.com'
  
curl -i -X GET \
  --url http://api-app-name.herokuapp.com/ \
  --header 'Host: mockbin.com'
```

##License

MIT.

This code is not endorsed nor supported by Heroku. No warranty expressed or implied. Use at your own risk.
