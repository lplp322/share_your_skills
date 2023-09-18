import express from "express";
import { Express, Request, Response } from "express";
import dotenv from "dotenv";
import initDB from "./config/dbInit";
import UserModel from "./models/userModel";
import * as userController from "./controllers/userController";

dotenv.config();

const messages = require("./config/messages");
const app: Express = express();
const port = process.env.NODE_PORT;

initDB();
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Share your skills server");
});

app.post("/new_user", (req: Request, res: Response) => {
  const newUser = new UserModel({
    login: req.body.login,
    password: req.body.password,
    name: req.body.name,
    skills: req.body.skills,
  });
  newUser.save();
  res.send("User saved!");
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

app.get("/a", (req: Request, res: Response) => {
  res.send("check");
});

app.delete("/users", userController.deleteAll);

app.get("/users", userController.getAll);

app.post("/users/login", userController.loginOne);

app.post("/users/register", userController.registerOne);
