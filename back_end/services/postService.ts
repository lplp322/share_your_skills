import { Types } from "mongoose";
import PostModel, { IPost } from "../models/postModel";

export async function getAll() {
  try {
    const posts = await PostModel.find({});
    return posts;
  } catch (error) {
    throw error;
  }
}

export async function getPost(idToFind: Types.ObjectId) {
  try {
    const foundPost = await PostModel.findById(idToFind);
    return foundPost;
  } catch (error) {
    return null;
  }
}

export async function getMyPosts(userId: Types.ObjectId) {
  try {
    const foundPosts = await PostModel.find({ userId: userId });
    return foundPosts;
  } catch (error) {
    return null;
  }
}

export async function getAssignedPosts(userId: Types.ObjectId) {
  try {
    const foundPosts = await PostModel.find({ assignedUserId: userId });
    return foundPosts;
  } catch (error) {
    return null;
  }
}

export async function getPostsBySkill(skillId: Types.ObjectId) {
  try {
    console.log("skillId", skillId);
    const foundPosts = [];
    for (const post of await PostModel.find({})) {
      console.log("post", post);
      if (post.skillIds.includes(skillId)) {
        foundPosts.push(post);
        console.log("foundPosts", foundPosts);
      }
    }
    return foundPosts;
  } catch (error) {
    return null;
  }
}

export async function createOne(post: IPost) {
  try {
    const createdPost = await PostModel.create(post);
    return createdPost._id.toString();
  } catch (error) {
    throw error;
  }
}

export async function updateOne(id: Types.ObjectId, post: IPost) {
  try {
    await PostModel.updateOne({ _id: id }, post);
  } catch (error) {
    throw error;
  }
}

export async function deleteOne(id: Types.ObjectId) {
  try {
    await PostModel.deleteOne({ _id: id });
  } catch (error) {
    throw error;
  }
}

export async function deleteAll() {
  try {
    await PostModel.deleteMany({});
  } catch (error) {
    throw error;
  }
}
