import mongoose from "mongoose";
import { Types } from "mongoose";
import { Request, Response, NextFunction } from "express";
import * as skillService from "../services/skillService";
import { ISkill } from "../models/skillModel";
import { CustomRequest } from "../middleware/auth";

const messages = require("../config/messages");

export const createOne = async (req: Request, res: Response) => {
  try {
    // we convert the string to an ObjectId
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const skillId = new Types.ObjectId(req.body.skillId);

    await skillService.createOne(userId, skillId);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("createOne : " + err);
  }
};

export const getAll = async (req: Request, res: Response) => {
  try {
    const skills = await skillService.getAll();
    res.status(messages.SUCCESSFUL).send(skills);
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("getAll : " + err);
  }
};

export const getSkillId = async (req: Request, res: Response) => {
  try {
    const skillId = await skillService.getSkillId(req.body.name);
    res.status(messages.SUCCESSFUL).send(skillId);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getSkillId : " + err);
  }
};

export const getSkills = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const skills = await skillService.getSkills(userId);
    res.status(messages.SUCCESSFUL).send(skills);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getSkills : " + err);
  }
};

export const deleteOne = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId(req.params.userId);
    const skillId = new Types.ObjectId(req.params.skillId);
    await skillService.deleteOne(userId, skillId);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteOne : " + err);
  }
};

export const deleteAll = async (req: Request, res: Response) => {
  try {
    await skillService.deleteAll();
    res.status(messages.SUCCESSFUL_DELETE).send("All skills deleted");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteAll : " + err);
  }
};

// to be deleted

export const forceAddSkillToDB = async (req: Request, res: Response) => {
  try {
    const skill: ISkill = {
      name: req.body.name,
      imageURL: req.body.imageURL,
      users: [],
    };
    console.log("skill added = ", skill);
    const skill_id = await skillService.forceAddSkillToDB(skill);

    if (skill_id) {
      res.status(messages.SUCCESSFUL_CREATION).send(skill_id);
    } else {
      res.status(messages.INTERNAL_SERVER_ERROR).send("Skill not added");
    }
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("forceAddSkillToDB : " + err);
  }
};
