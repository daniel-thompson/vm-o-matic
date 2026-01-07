# Quickstart

## Setting up serial access

This is useful in combination with `make headless`.

~~~sh
sudo systemctl enable serial-getty@ttyS0
sudo systemctl start serial-getty@ttyS0
~~~

## Setting up remote access

~~~sh
sudo apt update
sudo apt -y upgrade
sudo apt install openssh-server
~~~
