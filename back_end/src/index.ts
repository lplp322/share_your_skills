import express from "express";
import { Express, Request, Response } from "express";
import dotenv from "dotenv";

dotenv.config();

const app: Express = express();
const port = process.env.NODE_PORT;

app.get("/", (req: Request, res: Response) => {
  res.send("Share your skills server");
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

app.get("/a", (req: Request, res: Response) => {
  res.send("check");
});
