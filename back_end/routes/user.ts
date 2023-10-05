import { Express } from "express";
import * as userController from "../controllers/userController";
import { auth } from "../middleware/auth";

module.exports = function (app: Express) {
  app.get("/users", userController.getAll);

  app.post("/users/login", userController.loginOne);

  app.post(
    "/users/register",
    userController.registerOne,
    userController.loginOne
  );

  app.get("/users/getUser", auth, userController.getOne);

  // app.delete("/users", auth, userController.deleteAll);
  app.post("/users/changeMyAddress", auth, userController.changeAddress)
};
