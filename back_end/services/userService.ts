import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import UserModel, { IUser, ICredentials, Address } from "../models/userModel";
import dotenv from "dotenv";
import * as skillService from "./skillService";
import { Types } from "mongoose";

dotenv.config();

export async function register(user: IUser) {
  try {
    const newUser = new UserModel({
      login: user.login,
      password: user.password,
      name: user.name,
      skillIds: user.skillIds,
      address: user.address,
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
        user: foundUser,
        token: token,
      };
    } else {
      throw new Error("Wrong password");
    }
  } catch (error) {
    throw error;
  }
}

export async function changePassword(
  login: String,
  oldPassword: String,
  newPassword: String
) {
  try {
    const foundUser = await UserModel.findOne({ login: login });

    if (!foundUser) {
      throw new Error("User not found sorry");
    }

    const isMatch = bcrypt.compareSync(
      oldPassword.toString(),
      foundUser.password
    );
    if (isMatch) {
      foundUser.password = String(newPassword);
      foundUser.save();
    } else {
      throw new Error("Incorrect old password");
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

export async function updateAddress(id: Types.ObjectId, address: Address) {
  try {
    await UserModel.updateOne({ _id: id }, { address: address });
  } catch (error) {
    throw error;
  }
}

export async function updateName(id: Types.ObjectId, name: String) {
  try {
    await UserModel.updateOne({ _id: id }, { name: name });
  } catch (error) {
    throw error;
  }
}

export async function updateLogin(id: Types.ObjectId, login: String) {
  try {
    await UserModel.updateOne({ _id: id }, { login: login });
  } catch (error) {
    throw error;
  }
}
