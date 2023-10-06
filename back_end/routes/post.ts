import { Express } from "express";
import * as postController from "../controllers/postController";
import { auth } from "../middleware/auth";

module.exports = function (app: Express) {
  app.get("/posts", postController.getAll);

  app.get("/posts/getPost", auth, postController.getPost);

  app.get("/posts/getMyPosts", auth, postController.getMyPosts);

  app.get("/posts/getAssignedPosts", auth, postController.getAssignedPosts);

  app.get("/posts/getPostsBySkill", auth, postController.getPostsBySkill);

  app.post("/posts/addPost", auth, postController.createOne);

  app.put("/posts/modifyPost", auth, postController.updateOne);

  app.delete("/posts/deletePost", auth, postController.deleteOne);

  app.delete("/posts/deleteAll", auth, postController.deleteAll);
};
