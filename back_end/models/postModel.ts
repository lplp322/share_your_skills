import { model, Model, Schema, Types } from "mongoose";

export interface IPost {
  title: string;
  content: string;
  deadline: Date;
  status: string;
  userId: Types.ObjectId;
  skillIds: Array<Types.ObjectId>;
  assignedUserId?: Types.ObjectId;
}

const PostSchema = new Schema<IPost>({
  title: { type: String, required: true },
  content: { type: String, required: true },
  deadline: { type: Date, required: true },
  status: { type: String, required: true },
  userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  skillIds: { type: [Schema.Types.ObjectId], ref: "Skill", required: true },
  assignedUserId: { type: Schema.Types.ObjectId, ref: "User", required: false },
});

const PostModel: Model<IPost> = model("Post", PostSchema);

export default PostModel;
