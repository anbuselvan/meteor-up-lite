#!/bin/bash

# utilities
gyp_rebuild_inside_node_modules () {
  for npmModule in ./*; do
    cd $npmModule

    isBinaryModule="no"
    # recursively rebuild npm modules inside node_modules
    check_for_binary_modules () {
      if [ -f binding.gyp ]; then
        isBinaryModule="yes"
      fi

      if [ $isBinaryModule != "yes" ]; then
        if [ -d ./node_modules ]; then
          cd ./node_modules
          for module in ./*; do
            cd $module
            check_for_binary_modules
            cd ..
          done
          cd ../
        fi
      fi
    }

    check_for_binary_modules

    if [ $isBinaryModule == "yes" ]; then
      echo " > $npmModule: npm install due to binary npm modules"
      rm -rf node_modules
      if [ -f binding.gyp ]; then
        npm install
        node-gyp rebuild || :
      else
        npm install
      fi
    fi

    cd ..
  done
}

rebuild_binary_npm_modules () {
  for package in ./*; do
    if [ -d $package/node_modules ]; then
      cd $package/node_modules
        gyp_rebuild_inside_node_modules
      cd ../../
    elif [ -d $package/main/node_module ]; then
      cd $package/node_modules
        gyp_rebuild_inside_node_modules
      cd ../../../
    fi
  done
}

revert_app (){
  if [[ -d old_app ]]; then
    rm -rf app
    mv old_app app
    sudo stop <%= appName %> || :
    sudo start <%= appName %> || :

    echo "Latest deployment failed! Reverted back to the previous version." 1>&2
    exit 1
  else
    echo "App did not pick up! Please check app logs." 1>&2
    exit 1
  fi
}


# logic
set -e

TMP_DIR=/${HOME}/meteor/<%= appName %>/tmp
BUNDLE_DIR=${TMP_DIR}/bundle

cd ${TMP_DIR}
rm -rf bundle
tar xvzf bundle.tar.gz > /dev/null

# rebuilding fibers
cd ${BUNDLE_DIR}/programs/server

if [ -d ./npm ]; then
  cd npm
  rebuild_binary_npm_modules
  cd ../
fi

if [ -d ./node_modules ]; then
  cd ./node_modules
  gyp_rebuild_inside_node_modules
  cd ../
fi

if [ -f package.json ]; then
  # support for 0.9
  npm install
else
  # support for older versions
  npm install fibers
  npm install bcrypt
fi

cd /${HOME}/meteor/<%= appName %>/

# remove old app, if it exists
if [ -d old_app ]; then
  rm -rf old_app
fi

## backup current version
if [[ -d app ]]; then
  mv app old_app
fi

mv tmp/bundle app

#wait and check
echo "Waiting for MongoDB to initialize. (5 minutes)"
. /${HOME}/meteor/<%= appName %>/config/env.sh
wait-for-mongo ${MONGO_URL} 300000

# restart app
sudo stop <%= appName %> || :
sudo start <%= appName %> || :

echo "Waiting for <%= deployCheckWaitTime %> seconds while app is booting up"
sleep <%= deployCheckWaitTime %>

echo "Checking is app booted or not?"
curl localhost:${PORT} || revert_app
