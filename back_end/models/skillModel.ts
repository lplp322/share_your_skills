import { model, Model, Schema, Types } from "mongoose";

export interface ISkill {
  name: string;
  icon?: string;
  users?: Array<Types.ObjectId>;
}

const SkillSchema = new Schema<ISkill>({
  name: { type: String, required: true },
  icon: { type: String, required: false },
  users: [{ type: Types.ObjectId, ref: "User" }],
});

const SkillModel: Model<ISkill> = model("Skill", SkillSchema);

export default SkillModel;
