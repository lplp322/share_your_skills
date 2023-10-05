import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import UserModel, { IUser, ICredentials } from "../models/userModel";
import dotenv from "dotenv";
import * as skillService from "./skillService";

dotenv.config();

export async function register(user: IUser) {
  try {
    const newUser = new UserModel({
      login: user.login,
      password: user.password,
      name: user.name,
      skillIds: user.skillIds,
    });

    await newUser.save();

    // adding the user_id to the skills
    if (newUser.skillIds) {
      for (const skillId of newUser.skillIds) {
        await skillService.addUserToSkill(newUser._id!, skillId);
      }
    }
  } catch (error) {
    throw error;
  }
}

export async function login(userCredentials: ICredentials) {
  try {
    const foundUser = await UserModel.findOne({ login: userCredentials.login });

    if (!foundUser) {
      throw new Error("User not found sorry");
    }

    const isMatch = bcrypt.compareSync(
      userCredentials.password,
      foundUser.password
    );

    if (isMatch) {
      const token = jwt.sign(
        { _id: foundUser._id?.toString(), name: foundUser.name },
        process.env.SECRET_KEY!,
        { expiresIn: "2 days" }
      );
      return {
        user: { _id: foundUser._id?.toString(), name: foundUser.name },
        token: token,
      };
    } else {
      throw new Error("Wrong password");
    }
  } catch (error) {
    throw error;
  }
}

export async function getOne(idToFind: String) {
  try {
    const foundUser = await UserModel.findById(idToFind);
    return foundUser;
  } catch (error) {
    return null;
  }
}

export async function verifyLoginUnused(loginToFind: String) {
  try {
    const foundUser = await UserModel.findOne({ login: loginToFind });
    return foundUser;
  } catch (error) {
    return null;
  }
}

export async function getAll() {
  try {
    const users = await UserModel.find({});
    return users;
  } catch (error) {
    throw error;
  }
}

export async function deleteAll() {
  try {
    await UserModel.deleteMany({});
  } catch (error) {
    throw error;
  }
}
