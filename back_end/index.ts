import express from "express";
import { Express, Request, Response } from "express";
import dotenv from "dotenv";
import initDB from "./config/dbInit";
import http from "http";
import { Server } from "socket.io";

dotenv.config();

const app: Express = express();
const port = process.env.NODE_PORT;

initDB();
app.use(express.json());

const server = http.createServer(app);
const io = new Server(server);

app.get("/", (req: Request, res: Response) => {
  res.send("Share your skills server");
});

require("./routes/user")(app);
require("./routes/post")(app);
require("./routes/skill")(app);
require("./routes/chat")(io);

server.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});
