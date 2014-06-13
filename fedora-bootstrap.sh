#!/bin/sh -e
# Author: Márcio Almada
# Description: Installs Fedora 20 basics environment
# Usage: su -c "sh install.sh"
# set -e

set -o errexit

yum update -y

# basic
yum install -y nano wget tree gnome-tweak-tool deluge audacious audacious-plugin audacious-plugins-exotic gparted grsync

# git
yum install -y git git-cola

# phpbrew
yum install -y php php-devel php-pear bzip2-devel yum-utils bison re2c libmcrypt-devel libpqxx-devel libxslt-devel
curl -L -O https://raw.githubusercontent.com/c9s/phpbrew/master/phpbrew
chmod +x phpbrew
mv phpbrew /usr/local/bin/phpbrew
/usr/local/bin/phpbrew init
source /root/.phpbrew/bashrc
echo '# loading phpbrew' >> ~/.bashrc
echo 'source ~/.phpbrew/bashrc' >> ~/.bashrc

# fedy
curl http://satya164.github.io/fedy/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer
fedy --enable-log --exec google_chrome
fedy --enable-log --exec sublime_text3
fedy --enable-log --exec tor_browser
fedy --enable-log --exec config_selinux
fedy --enable-log --exec config_sudo
fedy --enable-log --exec oracle_jre
fedy --enable-log --exec adobe_flash

# VirtualBox
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
yum update -y
yum install -y VirtualBox.x86_64

# composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# phpunit
wget https://phar.phpunit.de/phpunit-beta.phar
chmod +x phpunit-beta.phar
mv phpunit-beta.phar /usr/local/bin/phpunit

# php-cs-fixer
wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
chmod +x /usr/local/bin/php-cs-fixer

# php repl
# composer global require psy/psysh
wget psysh.org/psysh
chmod +x psysh
mv psysh /usr/local/bin/psysh

# revisor
yum install -y revisor

echo "OK, all set :)"