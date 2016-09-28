# run this to setup an ubuntu box

apt-get install build-essential

apt-get install ffmpeg
apt-get install youtube-dl

apt-get install software-properties-common
apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install ruby2.3 ruby2.3-dev

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y nginx-extras passenger

# create the deploy user
useradd --create-home deploy
mkdir 0700 /home/deploy/.ssh
curl https://github.com/waltz.keys > /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh
chmod -R 0700 /home/deploy/.ssh

mkdir -p /var/www/exportgifsound.com
chown deploy:deploy /var/www/exportgifsound.com
