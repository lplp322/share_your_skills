import { Request, Response, NextFunction } from "express";
import * as postServices from "../services/postService";
import { IPost } from "../models/postModel";

const messages = require("../config/messages");

export const getAll = async (req: Request, res: Response) => {
    try {
        const posts = await postServices.getAll();
        res.status(messages.SUCCESSFUL_GET).send(posts);
    } catch (err) {
        return res.status(messages.INTERNAL_SERVER_ERROR).send("getAll : " + err);
    }
};

export const createOne = async (req: Request, res: Response) => {
    try {
        const post : IPost = {
            title: req.body.title,
            content: req.body.content,
            deadline: req.body.deadline,
            status: req.body.status,
            user_id: req.body.user_id,
            skills_id: req.body.skills_id,
            assigned_user_id: req.body.assigned_user_id,
        };
        await postServices.createOne(post);
        res.status(messages.SUCCESSFUL_CREATION).send("Post created");
    } catch (err) {
        return res.status(messages.INTERNAL_SERVER_ERROR).send("createOne : " + err);
    }
}

export const updateOne = async (req: Request, res: Response) => {
    try {
        const post : IPost = {
            title: req.body.title,
            content: req.body.content,
            deadline: req.body.deadline,
            status: req.body.status,
            user_id: req.body.user_id,
            skills_id: req.body.skills_id,
            assigned_user_id: req.body.assigned_user_id,
        };
        await postServices.updateOne(req.params.id, post);
        res.status(messages.SUCCESSFUL_UPDATE).send("Post updated");
    } catch (err) {
        return res.status(messages.INTERNAL_SERVER_ERROR).send("updateOne : " + err);
    }
}

export const deleteOne = async (req: Request, res: Response) => {
    try {
        await postServices.deleteOne(req.params.id);
        res.status(messages.SUCCESSFUL_DELETE).send("Post deleted");
    } catch (err) {
        return res.status(messages.INTERNAL_SERVER_ERROR).send("deleteOne : " + err);
    }
}
