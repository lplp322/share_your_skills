import express from "express";
import { Express, Request, Response } from "express";
import dotenv from "dotenv";
import initDB from "./config/dbInit";

import UserModel from "./models/userModel";
import * as userController from "./controllers/userController";
import { auth } from "./middleware/auth";

dotenv.config();

const app: Express = express();
const port = process.env.NODE_PORT;

initDB();
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Share your skills server");
});

app.get("/users", userController.getAll);

app.post("/users/login", userController.loginOne);

app.post(
  "/users/register",
  userController.registerOne,
  userController.loginOne
);

app.delete("/users", auth, userController.deleteAll);

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});