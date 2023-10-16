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

  app.delete("/users", auth, userController.deleteAll);

  // TODO : ALL of the following should be made with a PUT request
  app.post("/users/changeAddress", auth, userController.changeAddress);
  app.post("/users/changeName", auth, userController.changeName);
  app.post("/users/changeLogin", auth, userController.changeLogin);
  app.post("/users/changePassword", auth, userController.changePassword);
};
