dotnet publish -c Release ./webapp

docker build -t webappimage:v1 .

docker run --name webapp --publish 8080:80 --detach webappimage:v1
