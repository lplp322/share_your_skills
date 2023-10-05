import { Request, Response, NextFunction } from "express";
import * as userServices from "../services/userService";
import { ICredentials } from "../models/userModel";
import { CustomRequest } from "../middleware/auth";

const messages = require("../config/messages");

export const loginOne = async (req: Request, res: Response) => {
  try {
    const userCredentials: ICredentials = {
      login: req.body.login,
      password: req.body.password,
    };
    const userAndToken = await userServices.login(userCredentials);
    if (userAndToken) {
      console.log("userToken", userAndToken);
      res.status(messages.SUCCESSFUL_LOGIN).send(userAndToken.token);
    } else {
      res.status(messages.USER_NOT_FOUND).send("Login failed");
    }
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("loginOne : " + err);
  }
};

export const registerOne = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const userAlreadyExists = await userServices.verifyLoginUnused(
      req.body.login
    );
    if (userAlreadyExists !== null) {
      return res
        .status(messages.USER_ALREADY_EXISTS)
        .send("User already exists");
    }

    // verify that the input is valid
    const user = {
      login: req.body.login,
      password: req.body.password,
      name: req.body.name,
      skillIds: req.body.skillIds,
    };

    await userServices.register(user);
    // return res.status(messages.SUCCESSFUL_REGISTRATION).send("User registered");
    next();
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("registerOne : " + err);
  }
};

export const getAll = async (req: Request, res: Response) => {
  try {
    const users = await userServices.getAll();
    res.status(messages.SUCCESSFUL).send(users);
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("getAll : " + err);
  }
};

export const getOne = async (req: Request, res: Response) => {
  try {
    console.log("user_id", (req as CustomRequest).user_id);
    const user = await userServices.getOne((req as CustomRequest).user_id);
    if (!user) {
      throw new Error("User not found");
    }
    res.status(messages.SUCCESSFUL).send(user);
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("getOne : " + err);
  }
};

export const deleteAll = async (req: Request, res: Response) => {
  try {
    await userServices.deleteAll();
    res
      .status(messages.SUCCESSFUL_DELETE)
      .send("All users deleted by " + (req as CustomRequest).user_id);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteAll : " + err);
  }
};
