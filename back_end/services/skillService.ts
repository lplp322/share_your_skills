import { Schema, Types } from "mongoose";
import SkillModel from "../models/skillModel";
import UserModel from "../models/userModel";
import { ISkill } from "../models/skillModel";

export async function addOne(userId: Types.ObjectId, skillId: Types.ObjectId) {
  try {
    const user = await UserModel.findById(userId);
    const skill = await SkillModel.findById(skillId);
    if (!user) {
      throw new Error("User not found");
    }
    if (!skill) {
      throw new Error("Skill not found");
    }
    if (user.skillIds?.includes(skillId)) {
      throw new Error("Skill already added to user");
    }
    if (skill.users?.includes(userId)) {
      throw new Error("User already added to skill");
    }

    skill.users?.push(userId);
    await skill.save();

    const skillIds: Types.ObjectId[] | undefined = user.skillIds;
    skillIds?.push(skillId);
    await UserModel.updateOne({ _id: userId }, { skillIds: skillIds });
  } catch (err) {
    throw err;
  }
}

export async function addUserToSkill(
  userId: Types.ObjectId,
  skillId: Types.ObjectId
) {
  try {
    const user = await UserModel.findById(userId);
    const skill = await SkillModel.findById(skillId);
    if (!user) {
      throw new Error("User not found");
    }
    if (!skill) {
      throw new Error("Skill not found");
    }
    if (skill.users?.includes(userId)) {
      throw new Error("User already added to skill");
    }
    skill.users?.push(userId);
    await skill.save();
  } catch (err) {
    throw err;
  }
}

export async function getAll() {
  try {
    const skills = await SkillModel.find({});
    return skills;
  } catch (err) {
    throw err;
  }
}

export async function getSkillId(name: string) {
  try {
    const skill = await SkillModel.findOne({ name: name });
    if (!skill) {
      throw new Error("Skill not found");
    }
    return skill._id.toString();
  } catch (err) {
    throw err;
  }
}

export async function getSkills(userId: Types.ObjectId) {
  try {
    const user = await UserModel.findById(userId);
    if (!user) {
      throw new Error("User not found");
    }

    const skills = SkillModel.find({ _id: { $in: user.skillIds } });
    return skills;
  } catch (err) {
    throw err;
  }
}

export async function deleteOne(
  userId: Types.ObjectId,
  skillId: Types.ObjectId
) {
  try {
    const user = await UserModel.findById(userId);
    const skill = await SkillModel.findById(skillId);
    if (!user) {
      throw new Error("User not found");
    }
    if (!skill) {
      throw new Error("Skill not found");
    }

    skill.users = skill.users?.filter(
      (id) => id.toString() !== userId.toString()
    );
    await skill.save();

    const skillIds: Types.ObjectId[] | undefined = user.skillIds?.filter(
      (id) => id.toString() !== skillId.toString()
    );
    await UserModel.updateOne({ _id: userId }, { skillIds: skillIds });
  } catch (err) {
    throw err;
  }
}

export async function deleteAll() {
  try {
    await SkillModel.deleteMany({});
  } catch (err) {
    throw err;
  }
}

export async function forceAddSkillToDB(skill: ISkill) {
  try {
    const newSkill = new SkillModel({
      name: skill.name,
      imageURL: skill.icon,
      users: skill.users,
    });
    await newSkill.save();
    return newSkill._id.toString();
  } catch (err) {
    throw err;
  }
}
