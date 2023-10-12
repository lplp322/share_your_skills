// src/server.ts
import { Server, Socket } from "socket.io";
import MessageModel from "../models/messageModel";
import jwt, { Secret, JwtPayload } from "jsonwebtoken";
import { Types } from "mongoose";

module.exports = function (io: Server) {
  io.use((socket, next) => {
    try {
      const req = socket.request;
      const token = req.headers.authorization?.replace("Bearer ", "")!;

      if (!token) {
        next(
          new Error("No token provided (header 'Authorization' is missing)")
        );
      }

      const decoded = jwt.verify(token, process.env.SECRET_KEY!);

      const user_id = (decoded as JwtPayload)._id;
      req.headers.user_id = user_id;
      next();
    } catch (err) {
      next(Error("auth failed with:" + err));
    }
  });

  io.on("connection", (socket: Socket) => {
    console.log(`User connected: ${socket.id}`);

    socket.on("chat message", async (msg, callback) => {
      try {
        const senderId = String(socket.request.headers.user_id);
        const { recieverId, content } = msg;

        const message = new MessageModel({
          senderId: new Types.ObjectId(senderId),
          recieverId: new Types.ObjectId(recieverId),
          content: content,
          timestamp: new Date(),
        });
        await message.save();
        io.to(senderId)
          .to(recieverId)
          .emit("chat message", { senderId, content });
      } catch (error) {
        callback({
          status: "failed:" + error,
        });
      }
    });

    socket.on("join", (room, callback) => {
      try {
        socket.join(room);
      } catch (error) {
        callback({
          status: "failed:" + error,
        });
      }
    });

    socket.on("disconnect", () => {
      console.log(`User disconnected: ${socket.id}`);
    });
  });
};
