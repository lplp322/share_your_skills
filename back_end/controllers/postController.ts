import { Types } from "mongoose";
import { Request, Response, NextFunction } from "express";
import * as postServices from "../services/postService";
import * as skillServices from "../services/skillService";
import { IPost } from "../models/postModel";
import { CustomRequest } from "../middleware/auth";

const messages = require("../config/messages");

export const getAll = async (req: Request, res: Response) => {
  try {
    const posts = await postServices.getAll();
    res.status(messages.SUCCESSFUL).send(posts);
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("getAll : " + err);
  }
};

export const getPost = async (req: Request, res: Response) => {
  try {
    const postId = new Types.ObjectId(req.body.postId as string);
    const post = await postServices.getPost(postId);
    res.status(messages.SUCCESSFUL).send(post);
  } catch (err) {
    return res.status(messages.INTERNAL_SERVER_ERROR).send("getPost : " + err);
  }
};

export const getMyPosts = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const posts = await postServices.getMyPosts(userId);
    res.status(messages.SUCCESSFUL).send(posts);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getMyPosts : " + err);
  }
};

export const getAssignedPosts = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const posts = await postServices.getAssignedPosts(userId);
    res.status(messages.SUCCESSFUL).send(posts);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getAssignedPosts : " + err);
  }
};

export const getPostsBySkill = async (req: Request, res: Response) => {
  try {
    const skillId = new Types.ObjectId(req.body.skillId as string);
    const posts = await postServices.getPostsBySkill(skillId);
    res.status(messages.SUCCESSFUL).send(posts);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getPostsBySkill : " + err);
  }
};

export const getRecommendedPosts = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const posts = await postServices.getRecommendedPosts(userId);
    res.status(messages.SUCCESSFUL).send(posts);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("getRecommendedPosts : " + err);
  }
};

export const createOne = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const skillIds = req.body.skillIds.map(
      (skillId: string) => new Types.ObjectId(skillId)
    );

    const assignedUserId = new Types.ObjectId(req.body.assignedUserId);
    const deadline = new Date(req.body.deadline);

    const post: IPost = {
      title: req.body.title,
      content: req.body.content,
      deadline: deadline,
      status: req.body.status,
      userId: userId,
      skillIds: skillIds,
    };

    if (req.body.assignedUserId) {
      post.assignedUserId = assignedUserId;
    }

    const postId = await postServices.createOne(post);
    res.status(messages.SUCCESSFUL_CREATION).send(postId);
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("createOne : " + err);
  }
};

export const updateOne = async (req: Request, res: Response) => {
  try {
    const userId = new Types.ObjectId((req as CustomRequest).user_id);
    const skillIds = req.body.skillIds.map(
      (skillId: string) => new Types.ObjectId(skillId)
    );
    const postId = new Types.ObjectId(req.body.postId as string);
    const assignedUserId = new Types.ObjectId(req.body.assignedUserId);
    const deadline = new Date(req.body.deadline);
    const post: IPost = {
      title: req.body.title,
      content: req.body.content,
      deadline: deadline,
      status: req.body.status,
      userId: userId,
      skillIds: skillIds,
      assignedUserId: assignedUserId,
    };
    await postServices.updateOne(postId, post);
    res.status(messages.SUCCESSFUL_UPDATE).send("Post updated");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("updateOne : " + err);
  }
};

export const assignOne = async (req: Request, res: Response) => {
  try {
    const assignedUserId = new Types.ObjectId((req as CustomRequest).user_id);
    const postId = new Types.ObjectId(req.body.postId);

    const userSkills = await skillServices.getSkills(assignedUserId);
    const post = await postServices.getPost(postId);

    if (!post) {
      throw new Error("Post not found");
    }
    if (!userSkills) {
      throw new Error("User skills not found");
    }
    if (!post.skillIds) {
      throw new Error("Post skills not found");
    }

    // verify that users skills match at least one post skills
    let found = false;
    for (const userSkill of userSkills) {
      if (post.skillIds.includes(userSkill._id)) {
        found = true;
        break;
      }
    }
    if (!found) {
      throw new Error("User skills do not match post skills");
    }

    await postServices.updateAssignedUser(postId, assignedUserId);
    res.status(messages.SUCCESSFUL_UPDATE).send("Post assigned");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("assignOne : " + err);
  }
};

export const deleteOne = async (req: Request, res: Response) => {
  try {
    const postId = new Types.ObjectId(req.body.postId);
    await postServices.deleteOne(postId);
    res.status(messages.SUCCESSFUL_DELETE).send("Post deleted");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteOne : " + err);
  }
};

export const deleteAll = async (req: Request, res: Response) => {
  try {
    await postServices.deleteAll();
    res.status(messages.SUCCESSFUL_DELETE).send("All posts deleted");
  } catch (err) {
    return res
      .status(messages.INTERNAL_SERVER_ERROR)
      .send("deleteAll : " + err);
  }
};
