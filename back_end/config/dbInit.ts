import mongoose from "mongoose";

export default () => {
  mongoose
    .connect(process.env.MONGODB_URI!)
    .then(() => {
      console.log("Mongodb connected....");
    })
    .catch((err: Error) => console.log(err.message));

  mongoose.connection.once("connected", () => {
    console.log("Mongoose connected to db...");
  });

  mongoose.connection.once("error", (err: Error) => {
    console.log(err.message);
  });

  mongoose.connection.once("disconnected", () => {
    console.log("Mongoose connection is disconnected...");
  });
};
