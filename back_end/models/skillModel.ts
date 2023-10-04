import { model, Model, Schema, Types } from "mongoose";


export interface ISkill {
  name: string;
  users?: Array<Types.ObjectId>;
}

const SkillSchema = new Schema<ISkill>({
  name: { type: String, required: true },
  users : [{ type: Types.ObjectId, ref: 'User' }]
});

const SkillModel: Model<ISkill> = model("Skill", SkillSchema);

export default SkillModel;