import express from "express";
import { Express, Request, Response } from "express";
import dotenv from "dotenv";
import initDB from "./config/dbInit";
import User from "./models/userModel";

dotenv.config();

const app: Express = express();
const port = process.env.NODE_PORT;

initDB();
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Share your skills server");
});

app.post("/new_user", (req: Request, res: Response) => {
  const newUser = new User({
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
