import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import UserModel, { IUser, ICredentials } from "../models/userModel";
import dotenv from "dotenv";

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

// only used to verify that the user doesn't already exist when registering
export async function getOne(userCredentials: ICredentials) {
  try {
    const foundUser = await UserModel.findOne({ login: userCredentials.login });
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
