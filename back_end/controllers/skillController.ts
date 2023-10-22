import mongoose from "mongoose";
import { Types } from "mongoose";
import { Request, Response, NextFunction } from "express";
import * as skillService from "../services/skillService";
import { ISkill } from "../models/skillModel";
import { CustomRequest } from "../middleware/auth";

const messages = require("../config/messages");

export const addOne = async (req: Request, res: Response) => {
  try {
    const userId: Types.ObjectId = new Types.ObjectId(
      (req as CustomRequest).user_id
    );
    const skillId: Types.ObjectId = new Types.ObjectId(
      req.query.skillId as string
    );

    await skillService.addOne(userId, skillId);
    res.status(messages.SUCCESSFUL_CREATION).send("Skill added");
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
    const skillId: string = await skillService.getSkillId(
      req.query.name as string
    );

    res.status(messages.SUCCESSFUL).send(skillId);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getSkillId : " + err);
  }
};

export const getSkills = async (req: Request, res: Response) => {
  try {
    const userId: Types.ObjectId = new Types.ObjectId(
      (req as CustomRequest).user_id
    );
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
    const userId: Types.ObjectId = new Types.ObjectId(
      (req as CustomRequest).user_id
    );
    const skillId: Types.ObjectId = new Types.ObjectId(
      req.query.skillId as string
    );
    await skillService.deleteOne(userId, skillId);
    res.status(messages.SUCCESSFUL_DELETE).send("Skill deleted");
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

export const forceAddSkillToDB = async (req: Request, res: Response) => {
  try {
    const skill: ISkill = {
      name: req.body.name,
      icon: req.body.imageURL,
      users: [],
    };
    const skillId: string = await skillService.forceAddSkillToDB(skill);

    if (skillId) {
      res.status(messages.SUCCESSFUL_CREATION).send(skillId);
    } else {
      res.status(messages.INTERNAL_SERVER_ERROR).send("Skill not added");
    }
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("forceAddSkillToDB : " + err);
  }
};
