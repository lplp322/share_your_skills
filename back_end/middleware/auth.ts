import jwt, { Secret, JwtPayload } from "jsonwebtoken";
import { Request, Response, NextFunction } from "express";
import dotenv from "dotenv";
const messages = require("../config/messages");

dotenv.config();
export interface CustomRequest extends Request {
  user_id: string;
}

export const auth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const token: string | undefined = req
      .header("Authorization")
      ?.replace("Bearer ", "");

    if (!token) {
      throw new Error("No token provided (header 'Authorization' is missing)");
    }

    const decoded: string | jwt.JwtPayload = jwt.verify(
      token,
      process.env.SECRET_KEY!
    );

    const user_id = (decoded as JwtPayload)._id;
    (req as CustomRequest).user_id = user_id;

    next();
  } catch (err) {
    res.status(messages.UNAUTHORIZED).send("Please authenticate" + err);
  }
};
