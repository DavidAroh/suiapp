/// Module: suiapp
module suiapp::suiapp;

use std::ascii::String;

public struct UserProfile has key {
    id: UID,
    username: String,
    bio: String,
    points: u64,
    followers: u64,
    following: u64,
    posts: vector<object::ID>,
}

public struct Post has key, store {
    id: UID,
    post: String,
    like: u32,
    points_generated: u64,
    retweets: u32,
}

public fun createUser(username: String, bio: String, ctx: &mut TxContext) {
    let user = UserProfile {
        id: object::new(ctx),
        username,
        bio,
        points: 0,
        followers: 0,
        following: 0,
        posts: vector::empty(),
    };

    transfer::transfer(user, ctx.sender())
}

public fun createPost(user: &mut UserProfile, post: String, ctx: &mut TxContext) {
    let new_post = Post {
        id: object::new(ctx),
        post,
        like: 0,
        points_generated: 5,
        retweets: 0,
    };

    user.points = user.points + 5;
    user.following = user.following + 2;
    user.posts.push_back(new_post.id.to_inner());

    transfer::public_share_object(new_post)
}
