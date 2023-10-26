# Share your Skills

## Running the application locally

These are the basic steps to get the Flutter app up and running on your local machine.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Run Docker Desktop and wait while it will fully start 
- [Flutter & Dart](https://flutter.dev/docs/get-started/install)
- Install [Flutter's Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) for VS Code

## Installation Steps
Run the following commands
1. Clone the project
2. Navigate to the app's directory
3. Build the docker containers
   ```
     git clone https://github.com/lplp322/share_your_skills.git
     cd share_your_skills
     docker-compose up --build -d
     ```
4. Open IDE
   ```
   code .
   ```
5. Navigate to the project's front-end
6. Install dependencies
   ```
   cd front_end/share_your_skills
   flutter pub get
   ```
7. Select device
   
   Locate the VS Code status bar and select a device. For details, see [How to run a Flutter app](https://docs.flutter.dev/get-started/test-drive?tab=vscode)
   
   ![image](https://github.com/lplp322/share_your_skills/assets/69764581/3be6d95c-dba4-4a74-9b4f-43f9cc094c5b)
7. Run the app
   ```
   flutter run
   ```

### Populating the database
1. Open the [Postman's](https://app.getpostman.com/join-team?invite_code=ed425fbd0259defc6f31b1237d5ee67e&target_code=c39e211dac5fe53fd2a025fad2f789a6) API 

2. Set up skills data
-   2.1 Go to [`SYS/skill/POST skill`](https://bold-sunset-212289.postman.co/workspace/My-Workspace~84224976-5190-4f7e-86f4-9f945ea13200/request/26059886-a5544800-622d-4a05-9863-7aacdf3f2356?ctx=documentation)
-   2.2 Send the three JSON objects separately by adding the JSON object in the `Body` tab, and click `Send`

```javascript
{
    "name": "Gardening",
}
```
```javascript
{
    "name": "Cleaning",
}
```
```javascript
{
    "name": "Cooking",
}
```

## Using the app
1. Register an account or login with an existing account
  
-   **Home**
    -   Click  on `💚` to see recommended posts according to your skills
    -   Click on the rest of the skill icons to filter the post by skills
    -   Click on a post that matches your skill and assign yourself
-   **My Posts**
    -   Visualize your assigned posts and click on the post to see its details
    -   Visualize past assigned posts
-   **Add Posts**
    -   Create a new post
    -   Visualize your ongoing posts and its details
    -   Edit your ongoing posts
    -   Visualize your past posts          
-   **Profile**
    -   Visualize or edit user fields, when finished click `Save Profile`
    -   Add or remove skills to the profile
    -   Logout

### Creating posts
1. Go to `Add Posts` page and click on the icon `Create a New Post`
2. Fill the title with the following options `Gardening`, `Cleaning` or `Cooking` corresponding with the skill required for the post
3. Fill in the rest of the details
4. Click `Create` and refresh the page to see the newly created post in your `Ongoing Posts` section


### Stop server container in Docker

1. Run `docker-compose down`

   

