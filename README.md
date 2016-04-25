Basic run:
docker build -t <IMAGE_NAME>:<TAG> <DOCKER-DIR>
docker create -v /opt/charybdis/etc -v /opt/charybdis/logs --name irc-store charybdis /bin/true
docker run -p 6667:6667 -p 6697:6697 --volumes-from irc-store -d --name irc-live charybdis
docker exec -it <CONTAINER-NAME> bash
