import mongoose from "mongoose";
import { MongoMemoryServer } from "mongodb-memory-server";
import * as userService from "./../services/userService";
import { Address, IUser } from "../models/userModel";

let mongoServer: MongoMemoryServer;
const OLD_ENV = process.env;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = await mongoServer.getUri();
  await mongoose.connect(mongoUri);
  jest.resetModules(); // Most important - it clears the cache
  process.env = { ...OLD_ENV }; // Make a copy
  process.env = OLD_ENV;
  process.env.SECRET_KEY = "GroupomaniaFour";
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

describe("User Service Tests", () => {
  it("should register a user", async () => {
    const user: IUser = {
      login: "testuser",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };

    await userService.register(user);
    const foundUser = await userService.verifyLoginUnused("testuser");

    expect(foundUser).toBeDefined();
    expect(foundUser!.login).toBe("testuser");
  });

  it("should login with a valid user", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };

    await userService.register(user);

    // Attempt to log in
    const credentials = {
      login: "testuser",
      password: "testpassword",
    };

    const result = await userService.login(credentials);

    expect(result).toBeDefined();
    expect(result.token).toBeDefined();
  });

  it("should not login with an invalid password", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser",
      password: "testpassword",
      name: "Test User",
      skillIds: [],
    };

    await userService.register(user);

    // Attempt to log in with an incorrect password
    const credentials = {
      login: "testuser",
      password: "incorrectpassword",
    };

    try {
      await userService.login(credentials);
    } catch (error) {
      expect((error as Error).message).toBe("Wrong password");
    }
  });

  it("should update the password", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };
    await userService.register(user);

    // Update the password
    const newPassword = "newpassword";
    await userService.changePassword("testuser", "testpassword", newPassword);

    // Attempt to log in with the new password
    const credentials = {
      login: "testuser",
      password: newPassword,
    };
    const result = await userService.login(credentials);

    expect(result).toBeDefined();
    expect(result.token).toBeDefined();
  });

  it("should update the address", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser2",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };
    await userService.register(user);

    // Update the address
    const newAddress: Address = {
      city: "New City",
      street: "check",
      houseNumber: "12",
    };
    const login = await userService.login({
      login: "testuser2",
      password: "testpassword",
    });
    const id = login.user._id;
    await userService.updateAddress(id, newAddress);

    // Get the user and check the updated address
    const updatedUser = await userService.getOne(id);
    expect(updatedUser?.address).toEqual(newAddress);
  });

  it("should update the name", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser2",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };
    await userService.register(user);

    // Update the name
    const newName = "New Name";
    const login = await userService.login({
      login: "testuser2",
      password: "testpassword",
    });
    const id = login.user._id;
    await userService.updateName(id, newName);

    // Get the user and check the updated name
    const updatedUser = await userService.getOne(id);
    expect(updatedUser?.name).toBe(newName);
  });

  it("should update the login", async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser2",
      password: "testpassword",
      name: "Test User",
      skillIds: [
        /* Add skill IDs here */
      ],
    };
    await userService.register(user);

    // Update the login
    const newLogin = "newtestuser";
    const login = await userService.login({
      login: "testuser2",
      password: "testpassword",
    });
    const id = login.user._id;
    await userService.updateLogin(id, newLogin);

    // Attempt to log in with the new login
    const credentials = {
      login: newLogin,
      password: "testpassword",
    };
    const result = await userService.login(credentials);

    expect(result).toBeDefined();
    expect(result.token).toBeDefined();
  });
});
