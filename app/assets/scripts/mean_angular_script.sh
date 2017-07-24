server_config="server {
  listen 80;
  location / {
    proxy_pass http://$ip_addr:8000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
  }
}"

proj_conf=/etc/nginx/sites-available/$project_dir

# update ubuntu instance
sudo apt-get -y update
sudo apt-get -y install build-essential openssl libssl-dev pkg-config
sudo apt-get -y install nodejs nodejs-legacy
# install npm
sudo apt-get -y install npm
sudo npm cache clean -f
# fix npm permissions to install angular cli
sudo mkdir /usr/local/lib/node_modules
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
# install node.js
sudo npm install -g n
sudo n latest
# install nginx and git
sudo apt-get -y install nginx
sudo apt-get -y install git
# navigate to /var/www and git clone project
cd /var/www
sudo git clone $url
cd $project_dir
# install angular cli
npm install -g @angular/cli
# install node_modules
sudo npm install
cd public
sudo npm install
# create dist dir
sudo ng build
# set up nginx config
cd /etc/nginx/sites-available/
sudo touch $project_dir
sudo sh -c "echo '$server_config' >> '$proj_conf'"
# remove default file
sudo rm default
# create symbolic link
sudo ln -s /etc/nginx/sites-available/$project_dir /etc/nginx/sites-enabled/$project_dir
# remove other default file
cd ../sites-enabled/
sudo rm default
# install pm2
sudo npm install pm2 -g
sudo service nginx restart
# set up mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get -y update
sudo apt-get -y install mongodb
sudo killall mongod
# create data, db dir
cd /
sudo mkdir data
sudo mkdir data/db
# navigate to project dir
cd /var/www/$project_dir
# start mongodb and node.js server with pm2
sudo pm2 start mongod
sudo pm2 start server.js
sudo service nginx restart
