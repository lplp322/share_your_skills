import { Express } from "express";
import * as postController from "../controllers/postController";
import { auth } from "../middleware/auth";

module.exports = function (app: Express) {
  app.get("/posts", postController.getAll);

  app.get("/posts/getPost", auth, postController.getPost);

  app.get("/posts/getMyPosts", auth, postController.getMyPosts);

  app.get("/posts/getMyPastPosts", auth, postController.getMyPastPosts);

  app.get("/posts/getAssignedPosts", auth, postController.getAssignedPosts);

  app.get(
    "/posts/getPastAssignedPosts",
    auth,
    postController.getPastAssignedPosts
  );

  app.get("/posts/getPostsBySkill", auth, postController.getPostsBySkill);

  app.get(
    "/posts/getRecommendedPosts",
    auth,
    postController.getRecommendedPosts
  );

  app.post("/posts/addPost", auth, postController.createOne);

  app.put("/posts/updatePost", auth, postController.updateOne);

  app.put("/posts/assignPost", auth, postController.assignOne);

  app.delete("/posts/deletePost", auth, postController.deleteOne);

  app.delete("/posts/deleteAll", auth, postController.deleteAll);
};
