import { Express } from "express";
import * as postController from "../controllers/postController";
import { auth } from "../middleware/auth";
import { updateStatus } from "../middleware/updateStatus";

module.exports = function (app: Express) {
  app.get("/posts", updateStatus, postController.getAll);

  app.get("/posts/getPost", auth, updateStatus, postController.getPost);

  app.get("/posts/getMyPosts", auth, updateStatus, postController.getMyPosts);

  app.get(
    "/posts/getMyPastPosts",
    auth,
    updateStatus,
    postController.getMyPastPosts
  );

  app.get(
    "/posts/getAssignedPosts",
    auth,
    updateStatus,
    postController.getAssignedPosts
  );

  app.get(
    "/posts/getPastAssignedPosts",
    auth,
    updateStatus,
    postController.getPastAssignedPosts
  );

  app.get(
    "/posts/getPostsBySkill",
    auth,
    updateStatus,
    postController.getPostsBySkill
  );

  app.get(
    "/posts/getRecommendedPosts",
    auth,
    updateStatus,
    postController.getRecommendedPosts
  );

  app.post("/posts/addPost", auth, updateStatus, postController.createOne);

  app.put("/posts/updatePost", auth, updateStatus, postController.updateOne);

  app.put("/posts/assignPost", auth, updateStatus, postController.assignOne);

  app.delete("/posts/deletePost", auth, updateStatus, postController.deleteOne);

  app.delete("/posts/deleteAll", auth, updateStatus, postController.deleteAll);
};
