import { Express } from "express";
import * as postController from "../controllers/postController";
import { auth } from "../middleware/auth";


module.exports = function (app: Express) {
    app.get("/posts", postController.getAll);

    app.post("/posts", auth, postController.createOne);

    app.put("/posts/:id", auth, postController.updateOne);

    app.delete("/posts/:id", auth, postController.deleteOne);
}