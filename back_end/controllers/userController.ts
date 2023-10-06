import { Request, Response, NextFunction } from "express";
import * as userServices from "../services/userService";
import { Address, ICredentials, IUser } from "../models/userModel";
import { CustomRequest } from "../middleware/auth";
import { Types } from "mongoose";

const messages = require("../config/messages");

export const loginOne = async (req: Request, res: Response) => {
  try {
    const userCredentials: ICredentials = {
      login: req.body.login,
      password: req.body.password,
    };
    const userAndToken = await userServices.login(userCredentials);
    if (userAndToken) {
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
    const user: IUser = {
      login: req.body.login,
      password: req.body.password,
      name: req.body.name,
      skillIds: req.body.skillIds,
      address: req.body.address,
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
    res.status(messages.SUCCESSFUL_DELETE).send("All users deleted");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteAll : " + err);
  }
};

export const changeAddress = async (req: Request, res: Response) => {
  try {
    const id = new Types.ObjectId((req as CustomRequest).user_id);
    const address: Address = {
      city: String(req.body.city),
      street: String(req.body.street),
      houseNumber: String(req.body.houseNumber),
    };
    try {
      await userServices.updateAddress(id, address);
      return res.status(messages.SUCCESSFUL_UPDATE).send("Address updated");
    } catch (err) {
      return res
        .status(messages.INTERNAL_SERVER_ERROR)
        .send("changeAddress : " + err);
    }
  } catch (err) {
    return res.status(messages.BAD_REQUEST).send("Your address is incorrect");
  }
};

export const changeName = async (req: Request, res: Response) => {
  const id = new Types.ObjectId((req as CustomRequest).user_id);
  const name: String = String(req.body.name);
  if (name === undefined || name === "") {
    return res.status(messages.BAD_REQUEST).send("Your name is missing");
  }
  try {
    await userServices.updateName(id, name);
    return res.status(messages.SUCCESSFUL_UPDATE).send("Name updated");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("changeName : " + err);
  }
};

export const changeLogin = async (req: Request, res: Response) => {
  const id = new Types.ObjectId((req as CustomRequest).user_id);
  const login: String = String(req.body.newLogin);
  if (login === undefined || login === "") {
    return res.status(messages.BAD_REQUEST).send("Your login is missing");
  }
  const userAlreadyExists = await userServices.verifyLoginUnused(login);
  if (userAlreadyExists !== null) {
    return res.status(messages.USER_ALREADY_EXISTS).send("User already exists");
  }
  try {
    await userServices.updateLogin(id, login);
    return res.status(messages.SUCCESSFUL_UPDATE).send("Login updated");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("changeName : " + err);
  }
};

export const changePassword = async (req: Request, res: Response) => {
  const id = new Types.ObjectId((req as CustomRequest).user_id);
  const login: String = String(req.body.login);
  const oldPassword: String = String(req.body.oldPassword);
  const newPassword: String = String(req.body.newPassword);
  try {
    await userServices.changePassword(login, oldPassword, newPassword);
    return res.status(messages.SUCCESSFUL_UPDATE).send("Password updated");
  } catch (err) {
    return res.status(messages.BAD_REQUEST).send("changeName : " + err);
  }
};
