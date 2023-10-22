import mongoose, { ObjectId } from "mongoose";
import { MongoMemoryServer } from "mongodb-memory-server";
import * as userService from "./../services/userService";
import * as skillService from "./../services/skillService";
import { IUser } from "../models/userModel";

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

describe("Skill Service Tests", () => {
  let userId: mongoose.Types.ObjectId;
  let skillId: mongoose.Types.ObjectId;

  beforeAll(async () => {
    // Register a test user
    const user: IUser = {
      login: "testuser",
      password: "testpassword",
      name: "Test User",
      skillIds: [],
    };
    await userService.register(user);

    // Log in and get the user's ID
    const loginResult = await userService.login({
      login: "testuser",
      password: "testpassword",
    });
    userId = loginResult.user._id!;

    // Create a test skill
    const skill = {
      name: "Test Skill",
      icon: "icon.png",
      users: [],
    };
    skillId = new mongoose.Types.ObjectId(
      await skillService.forceAddSkillToDB(skill)
    );
  });

  it("should get a list of all skills", async () => {
    // Get a list of all skills
    const skills = await skillService.getAll();

    // Ensure that the list is an array
    expect(Array.isArray(skills)).toBeTruthy();
  });

  it("should get skill ID by name", async () => {
    // Get a skill ID by name
    const skillName = "Test Skill";
    const foundSkillId = await skillService.getSkillId(skillName);

    // Ensure the found skill ID matches the expected skill ID
    expect(foundSkillId).toBe(skillId.toString());
  });

  it("should get a list of skills for a user", async () => {
    // Get a list of skills for the user
    const userSkills = await skillService.getSkills(userId);

    // Ensure that the list is an array
    expect(Array.isArray(userSkills)).toBeTruthy();
  });

  it("should delete a skill from a user", async () => {
    // Remove the test skill from the user
    await skillService.deleteOne(userId, skillId);

    // Get the user and check if the skill is removed
    const user = await userService.getOne(userId);
    expect(user?.skillIds).not.toContainEqual(skillId);
  });
});
