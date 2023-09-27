import { Request, Response, NextFunction } from "express";
import * as userServices from "../services/userService";
import { ICredentials } from "../models/userModel";
//import { CustomRequest } from "../middleware/auth";

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
    // check if the user already exists
    const userCredentials: ICredentials = {
      login: req.body.login,
      password: req.body.password,
    };
    const userAlreadyExists = await userServices.getOne(userCredentials);
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
      skills: req.body.skills,
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

export const deleteAll = async (req: Request, res: Response) => {
  try {
    await userServices.deleteAll();
    res.status(messages.SUCCESSFUL_DELETE).send("All users deleted");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteAll : " + err);
  }
};
