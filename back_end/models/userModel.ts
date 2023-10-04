import { model, Model, Schema, Types } from "mongoose";
import bcrypt from "bcrypt";

export interface IUser {
  login: string;
  password: string;
  name?: string;
  skillIds?: Array<Types.ObjectId>;
}

export interface ICredentials {
  login: string;
  password: string;
}

const UserSchema = new Schema<IUser>({
  login: { type: String, required: true },
  password: { type: String, required: true },
  name: { type: String, required: false },
  skillIds: [{ type: Types.ObjectId, ref: 'Skill' }],
});

const saltRounds = 8;

UserSchema.pre<IUser>("save", function (next) {
  this.password = bcrypt.hashSync(this.password, saltRounds);
  next();
});

const UserModel: Model<IUser> = model("User", UserSchema);

export default UserModel;
