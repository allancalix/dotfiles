function docker_clean
  docker rm (docker ps -aq)
  docker rmi (docker images -aq)
end
