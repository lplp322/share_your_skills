import { model, Model, Schema, Document } from "mongoose";
import bcrypt from "bcrypt";
import SkillModel, { ISkill } from "./skillModel";

export interface IUser {
  login: string;
  password: string;
  name?: string;
  skillIds?: Array<Schema.Types.ObjectId>;
}

export interface ICredentials {
  login: string;
  password: string;
}

const UserSchema = new Schema<IUser>({
  login: { type: String, required: true },
  password: { type: String, required: true },
  name: { type: String, required: false },
  skillIds: [{ type: Schema.Types.ObjectId, ref: 'Skill' }],
});

const saltRounds = 8;

UserSchema.pre<IUser>("save", function (next) {
  this.password = bcrypt.hashSync(this.password, saltRounds);
  next();
});

const UserModel: Model<IUser> = model("User", UserSchema);

export default UserModel;
