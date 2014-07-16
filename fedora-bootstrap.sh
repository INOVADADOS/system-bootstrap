#!/usr/bin/env bash
# Author: Márcio Almada
# Description: Installs Fedora 20 basics environment
# Usage: sudo bash fedora-bootstrap.sh

trap "exit 1" ERR

USERHOME=$(eval "echo ~$SUDO_USER")
USERBASHRC="$USERHOME/.bashrc"

# add virtual box repo
echo -e "\nAdding Virtual Box repo to yum...\n"
curl http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo

# update distro
echo -e "\nUpdating distro...\n"
yum clean all
yum -y update

# basic packages
echo -e "\nInstalling basic packages with yum...\n"
yum install -y wget curl nano tree gparted grsync \
gnome-tweak-tool \
audacious audacious-plugin audacious-plugins-exotic \
git git-daemon git-cola \
livecd-tools spin-kickstarts system-config-kickstart qemu gstream \
deluge xchat polari \
pgadmin3

# install fedy
echo -e "\nInstalling Fedy...\n"
command -v fedy || su -c "curl http://satya164.github.io/fedy/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer"

echo -e "\nInstalling basic programs with Fedy...\n"
fedy --enable-log --exec config_selinux
fedy --enable-log --exec sublime_text3
fedy --enable-log --exec google_chrome
fedy --enable-log --exec tor_browser
fedy --enable-log --exec config_sudo
fedy --enable-log --exec oracle_jre 
fedy --enable-log --exec nautilus_dropbox
fedy --enable-log --exec core_fonts
fedy --enable-log --exec adobe_flash
fedy --enable-log --exec media_codecs
fedy --enable-log --exec rpmfusion_repos

# install docker
yum -y install docker-io && systemctl enable docker

# install phpbrew requirements
echo -e "\nInstalling phpbrew requirements...\n"
yum install -y php php-devel php-pear bzip2-devel yum-utils bison re2c libmcrypt-devel libpqxx-devel libxslt-devel php-mbstring php-pgsql php-mcrypt

# install phpbrew
echo -e "\nInstalling phpbrew...\n"
curl -L -O https://raw.githubusercontent.com/phpbrew/phpbrew/master/phpbrew
chmod +x phpbrew
mv phpbrew /usr/local/bin/phpbrew
runuser -l $SUDO_USER -c '/usr/local/bin/phpbrew init'
curl https://raw.githubusercontent.com/phpbrew/phpbrew/master/completion/bash/_phpbrew -o "$USERHOME/.phpbrew/comp"
grep -q '# loading phpbrew' "$USERBASHRC" || echo -e "\n# loading phpbrew\nsource ~/.phpbrew/bashrc && source ~/.phpbrew/comp\n" >> $USERBASHRC
    
# echo -e "\nInstalling php 5.5.13 with phpbrew...\n"
# /usr/local/bin/phpbrew install 5.5.13 +default+dbs-json+tokenizer && phpbrew ext install phar && phpbrew ext install xdebug

# VirtualBox
# yum install -y VirtualBox

# composer
echo -e "\nInstalling composer...\n"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# add vendor/bin to path
grep -q '# add vendor/bin to path' "$USERBASHRC" || echo -e '\n# add vendor/bin to path\nexport PATH=vendor/bin:$PATH\n' >> $USERBASHRC

# phpunit
echo -e "\nInstalling phpunit...\n"
curl https://phar.phpunit.de/phpunit-beta.phar -o /usr/local/bin/phpunit
chmod +x /usr/local/bin/phpunit

# php-cs-fixer
echo -e "\nInstalling php-cs-fixer...\n"
curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer
chmod +x /usr/local/bin/php-cs-fixer

# php repl
echo -e "\nInstalling psysh (php repl)...\n"
curl http://psysh.org/psysh -o /usr/local/bin/psysh
chmod +x /usr/local/bin/psysh

echo -e "\nAll set!\n"

exit 0
