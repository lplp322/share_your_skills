import * as postServices from "../services/postService";
import { Request, Response, NextFunction } from "express";

export const updateStatus = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const posts = await postServices.getAll();
    for (const post of posts) {
      postServices.updateStatus(post);
    }
    next();
  } catch (error) {
    throw error;
  }
};
