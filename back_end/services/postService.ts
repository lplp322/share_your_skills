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

export async function createOne(post: IPost) {
  try {
    await PostModel.create(post);
  } catch (error) {
    throw error;
  }
}

// id should be type Schema.Types.ObjectId, some test need to be done
// maybe it converts automatically when we use it in the function
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
