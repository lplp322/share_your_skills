import { Express } from "express";
import { auth } from "../middleware/auth";
import * as skillController from "../controllers/skillController";


module.exports = function (app: Express) {
    app.get("/user/:userId/skills", skillController.getAll);

    app.post("/user/:userId/skills/:skillId", auth, skillController.createOne);

    app.delete("/user/:userId/skills/:skillId", auth, skillController.deleteOne);

    // no update because the data is stored in the db and is not modifiable
}

