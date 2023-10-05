import { model, Model, Schema, Types } from "mongoose";
import bcrypt from "bcrypt";

export interface Address {
  city: string;
  street: string;
  houseNumber: string;
}

export interface IUser {
  login: string;
  password: string;
  name?: string;
  skillIds?: Array<Types.ObjectId>;
  address?: Address;
}

export interface ICredentials {
  login: string;
  password: string;
}

const UserSchema = new Schema<IUser>({
  login: { type: String, required: true, index: true },
  password: { type: String, required: true },
  name: { type: String, required: false },
  skillIds: [{ type: Types.ObjectId, ref: "Skill" }],
  address: {
    city: { type: String, required: false },
    street: { type: String, required: false },
    houseNumber: { type: String, required: false },
  },
});

const saltRounds = 8;

UserSchema.pre<IUser>("save", function (next) {
  this.password = bcrypt.hashSync(this.password, saltRounds);
  next();
});

const UserModel: Model<IUser> = model("User", UserSchema);

export default UserModel;
