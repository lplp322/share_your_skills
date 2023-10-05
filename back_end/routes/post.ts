import { Express } from "express";
import * as postController from "../controllers/postController";
import { auth } from "../middleware/auth";

module.exports = function (app: Express) {
  app.get("/posts", postController.getAll);

  app.post("/posts/addPost", auth, postController.createOne);

  app.put("/posts/modifyPost", auth, postController.updateOne);

  app.delete("/posts/deletePost", auth, postController.deleteOne);

  //   app.delete("/posts/deleteAll", auth, postController.deleteAll);
};
