brew install gnupg
gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby

source ~/.bashrc
source ~/.bash_profile

rvm install 2.7.2 --disable-binary
rvm use 2.7.2
rvm use 2.7.2 --default
