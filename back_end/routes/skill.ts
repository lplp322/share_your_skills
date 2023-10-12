import { Express } from "express";
import { auth } from "../middleware/auth";
import * as skillController from "../controllers/skillController";

module.exports = function (app: Express) {
  app.get("/skills", skillController.getAll);

  app.get("/skills/getSkillId", auth, skillController.getSkillId);

  app.get("/skills/getSkills", auth, skillController.getSkills);

  app.post("/skills/addSkill", auth, skillController.createOne);

  //   app.delete("/skills/modifySkill", auth, skillController.modifyOne);

  app.delete("/skills/deleteSkill", auth, skillController.deleteOne);

  app.delete("/skills/deleteAll", auth, skillController.deleteAll);

  // no update because the data is stored in the db and is not modifiable

  // to be deleted later :

  app.post("/skills/forceAddSkillToDB", skillController.forceAddSkillToDB);
};
