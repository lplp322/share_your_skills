import { model, Model, Schema } from "mongoose";

export interface IPost {
  title: string;
  content: string;
  deadline: Date;
  status: string;
  user_id: Schema.Types.ObjectId;
  skills_id: Array<Schema.Types.ObjectId>;
  assigned_user_id: Schema.Types.ObjectId;
}

const PostSchema = new Schema<IPost>({
  title: { type: String, required: true },
  content: { type: String, required: true },
  deadline: { type: Date, required: true },
  status: { type: String, required: true },
  user_id: { type: Schema.Types.ObjectId, ref:'User', required: true },
  skills_id: { type: [Schema.Types.ObjectId], ref:'Skill', required: true },
  assigned_user_id: { type: Schema.Types.ObjectId, ref:'User', required: false },
});

const PostModel: Model<IPost> = model("Post", PostSchema);

export default PostModel;
