import { model, Model, Schema } from "mongoose";


export interface ISkill {
  name: string;
  users?: Array<Schema.Types.ObjectId>;
}

const SkillSchema = new Schema<ISkill>({
  name: { type: String, required: true },
  users : [{ type: Schema.Types.ObjectId, ref: 'User' }]
});

const SkillModel: Model<ISkill> = model("Skill", SkillSchema);

export default SkillModel;