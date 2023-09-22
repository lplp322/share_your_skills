import { model, Model, Schema } from "mongoose";


export interface ISkill {
  name: string;
}

const SkillSchema = new Schema<ISkill>({
  name: { type: String, required: true },
});

const SkillModel: Model<ISkill> = model("Skill", SkillSchema);
