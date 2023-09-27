import mongoose from 'mongoose';
import { Request, Response, NextFunction } from "express";
import * as skillService from "../services/skillService";
import { ISkill } from "../models/skillModel";


const messages = require("../config/messages");

export const createOne = async (req: Request, res: Response) => {
    try{
        // we convert the string to an ObjectId
        const userId = new mongoose.Schema.Types.ObjectId(req.params.userId);
        const skillId = new mongoose.Schema.Types.ObjectId(req.params.skillId);

        await skillService.createOne(userId, skillId);
    }
    catch(err){
        return res.status(messages.INTERNAL_SERVER_ERROR).send("createOne : " + err);
    }
};

export const getAll = async (req: Request, res: Response) => {
    try{
        const userId = new mongoose.Schema.Types.ObjectId(req.params.userId);
        const skills = await skillService.getAll(userId);
        res.status(messages.SUCCESSFUL_GET).send(skills);
    }
    catch(err){
        return res.status(messages.INTERNAL_SERVER_ERROR).send("getAll : " + err);
    }
};

export const deleteOne = async (req: Request, res: Response) => {
    try{
        const userId = new mongoose.Schema.Types.ObjectId(req.params.userId);
        const skillId = new mongoose.Schema.Types.ObjectId(req.params.skillId);
        await skillService.deleteOne(userId, skillId);
    }
    catch(err){
        return res.status(messages.INTERNAL_SERVER_ERROR).send("deleteOne : " + err);
    }
};