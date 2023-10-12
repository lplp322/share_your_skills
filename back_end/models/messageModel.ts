import { model, Model, Schema, Types } from "mongoose";

export interface IMessage {
  senderId: Types.ObjectId;
  recieverId: Types.ObjectId;
  content: string;
  timestamp: Date;
}

const MessageSchema = new Schema<IMessage>({
  senderId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  recieverId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  content: { type: String, required: true },
  timestamp: { type: Date, required: true },
});

const MessageModel: Model<IMessage> = model("Message", MessageSchema);

export default MessageModel;
