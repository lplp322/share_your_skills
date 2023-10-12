# share_your_skills

### Start server with Docker

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Run Docker Desktop and wait while it will fully start
3. In the terminal move to the root folder of the project
4. Run command `docker-compose up --build -d`. It will run application in Docker
5. Now you can access the application via `localhost:8000`

### Stop server container in Docker

1. Run `docker-compose down`

### Use of tokens

1. Register by sending a POST request with a JSON format
2. Login by sending a POST request with only "login" and "password"
3. Retreive the token from login function (userService.ts)
4. Put it in the header associated to the key "Authorization" for the routes that require it

