import { model, Schema } from "mongoose";

interface IUser {
  login: String;
  password: String;
  name?: String;
  skills?: Array<String>;
}

const UserSchema = new Schema<IUser>({
  login: { type: String, required: true },
  password: { type: String, required: true },
  name: { type: String, required: false },
  skills: { type: [String], required: false },
});

const User = model<IUser>("User", UserSchema);

export default User;
