"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
exports.default = () => {
    mongoose_1.default
        .connect(process.env.MONGODB_URI)
        .then(() => {
        console.log("Mongodb connected....");
    })
        .catch((err) => console.log(err.message));
    mongoose_1.default.connection.once("connected", () => {
        console.log("Mongoose connected to db...");
    });
    mongoose_1.default.connection.once("error", (err) => {
        console.log(err.message);
    });
    mongoose_1.default.connection.once("disconnected", () => {
        console.log("Mongoose connection is disconnected...");
    });
};
