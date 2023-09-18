import UserModel, { IUser, ICredentials } from "../models/userModel";
import bcrypt from 'bcrypt';

export async function register(user: IUser) {
  try {
    const newUser = new UserModel({
      login: user.login,
      password: user.password,
      name: user.name,
      skills: user.skills,
    });
    newUser.save();
  } catch (error) {
    throw error;
  }
}

export async function login(userCredentials: ICredentials) {
  try {
    const foundUser = await UserModel.findOne({ login: userCredentials.login });
    if (!foundUser) {
      throw new Error("User not found");
    }
    const isMatch = bcrypt.compareSync(userCredentials.password, foundUser.password);
      if (!isMatch) {
        throw new Error("Wrong password");
      }
    return foundUser;
  } catch (error) {
    throw error;
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