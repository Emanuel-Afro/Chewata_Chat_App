
# Chewata_Chat_App

Chewata_Chat_App is a Full Stack Chatting App. Uses Socket.io for real time communication and stores user details(sensetive) in encrypted format in Mongo DB Database.


## Technolgoy Stack

**Client:** React JS.

**Server:** Node JS, Express JS.

**Database:** Mongo DB.



## Screenshots


## Run Locally

Clone the project

```bash
    git clone https://github.com/Emanuel-Afro/Chewata_Chat_App.git
```

Go to the project directory

```bash
    cd ChatApp
```

Install dependencies

```bash
    npm install
```
```bash
    cd frontend/
    npm install
  ```

Start the server

```bash
    npm run start
```
Start the client

```bash
    //open new terminal
    cd frontend
    npm run start
```


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`PORT=5000`

`MONGO_URI = 'Your mongodb api'`


`JWT_SECRET = "your secret name"`


`NODE_ENV = production`

`REACT_APP_SECRET_KEY = 'your number(atleast 10 digit)'`

