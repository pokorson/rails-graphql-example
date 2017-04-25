namespace :Graph do
  CommentType = GraphQL::ObjectType.define do
    name 'Comment'
    description 'A blog post comment'

    field :id, !types.ID
    field :author, !types.String
    field :content, !types.String
  end

  PostType = GraphQL::ObjectType.define do
    name 'Post'
    description 'A blog post'

    field :id, !types.ID
    field :title, !types.String
    field :body, !types.String
    field :comments, types[!CommentType]
  end

  QueryType = GraphQL::ObjectType.define do
    name 'Query'
    description 'The query root of this schema'

    field :allPosts do
      type types[PostType]
      resolve ->(_obj, args, _ctx) { Post.all }
    end

    field :allPostsWithComments do
      type types[PostType]
      resolve ->(_obj, args, _ctx) { Post.includes(:comments).all }
    end

    field :post do
      type PostType
      argument :id, !types.ID
      resolve ->(_obj, args, _ctx) { Post.find(args['id']) }
    end

    field :allComments do
      type types[CommentType]
      resolve ->(_obj, args, _ctx) { Comment.all }
    end
  end

  # Then create your schema
  Schema = GraphQL::Schema.define do
    query QueryType
  end
end
