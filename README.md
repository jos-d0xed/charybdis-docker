# Basic Getting Started

* docker build -t charybdis:latest charybdis-docker   # Last argument is the directory of this repo
* docker create -v /opt/charybdis/etc -v /opt/charybdis/logs --name irc-store charybdis /bin/true   #Create persistent storage
* docker run -p 6667:6667 -p 6697:6697 --volumes-from irc-store -d --name irc-live charybdis
* docker exec -it irc-live bash   # Gen SSL, make any further changes
