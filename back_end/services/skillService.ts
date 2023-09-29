import { Schema } from "mongoose";
import SkillModel from "../models/skillModel";
import UserModel from "../models/userModel";



export async function createOne(userId: Schema.Types.ObjectId, skillId: Schema.Types.ObjectId) {
    try {
        const user = await UserModel.findById(userId);
        const skill = await SkillModel.findById(skillId);
        if (!user) {
            throw new Error("User not found");
        }
        if (!skill) {
            throw new Error("Skill not found");
        }
        skill.users?.push(userId);
        user.skillIds?.push(skillId);
        await user.save();
        await skill.save();
    }
    catch (err) {
        throw err;
    }
}

export async function getAll(userId: Schema.Types.ObjectId) {
    try {
        const user = await UserModel.findById(userId);
        if (!user) {
            throw new Error("User not found");
        }
        const userSkills = SkillModel.find({ users: userId });
        // we return the skills of the user (maybe we could return only their names)
        return userSkills
    }
    catch (err) {
        throw err;
    }
}

export async function deleteOne(userId: Schema.Types.ObjectId, skillId: Schema.Types.ObjectId) {
    try {
        const user = await UserModel.findById(userId);
        const skill = await SkillModel.findById(skillId);
        if (!user) {
            throw new Error("User not found");
        }
        if (!skill) {
            throw new Error("Skill not found");
        }

        user.skillIds = user.skillIds?.filter((id) => id !== skillId);
        skill.users = skill.users?.filter((id) => id !== userId);
        
        await user.save();
        await skill.save();
    }
    catch (err) {
        throw err;
    }
}
