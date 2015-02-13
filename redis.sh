#!/usr/bin/env bash
# -------------------------------------------------------------------
# Copyright (c) 2015 Manoel Domingues.  All Rights Reserved.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain
# a copy of the License at
#
#   http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# -------------------------------------------------------------------

# Fix error message in system
sudo locale-gen UTF-8

# Updating repos
sudo apt-get -y update

# Install deps
sudo apt-get -y install make

# Prepare redis
mkdir /opt/redis
cd /opt/redis

# Use latest stable
wget http://download.redis.io/redis-stable.tar.gz

# Only update newer files
tar -xz --keep-newer-files -f redis-stable.tar.gz

# Compile redis
cd redis-stable
make
make install

# Change default config file
mkdir -p /etc/redis
mkdir /var/redis
chmod -R 777 /var/redis
rm /etc/redis.conf
cp -u /vagrant/data/redis.conf /etc/redis/6379.conf
cp -u /vagrant/data/redis.init.d /etc/init.d/redis_6379

# Create a redis user
useradd redis

# Add redis as a service
update-rc.d redis_6379 defaults
chmod a+x /etc/init.d/redis_6379

# start redis
/etc/init.d/redis_6379 start
