CREATE TABLE t_HashtagPost(
    [id] TEXT NOT NULL PRIMARY KEY,
    [hashtag] TEXT NOT NULL,
    [postId] TEXT NOT NULL,
    FOREIGN KEY([postId]) REFERENCES t_Post([id]) ON DELETE CASCADE
);

CREATE TABLE t_InterestingPost(
    [id] TEXT NOT NULL PRIMARY KEY,
    [postId] TEXT NOT NULL,
    FOREIGN KEY([postId]) REFERENCES t_Post([id]) ON DELETE CASCADE
);

CREATE TABLE t_SubscriptionPost(
    [id] TEXT NOT NULL PRIMARY KEY,
    [postId] TEXT NOT NULL,
    FOREIGN KEY([postId]) REFERENCES t_Post([id]) ON DELETE CASCADE
);


CREATE TABLE t_UserPost(
    [id] TEXT NOT NULL PRIMARY KEY,
    [userId] TEXT NOT NULL,
    [postId] TEXT NOT NULL,
    FOREIGN KEY([postId]) REFERENCES t_Post([id]) ON DELETE CASCADE
);

CREATE TABLE t_Post(
    [id] TEXT NOT NULL PRIMARY KEY,
    [userId] TEXT NOT NULL,
    [description] TEXT NOT NULL,
    [amountLikes] INT NULL,
    [amountComments] INT NULL,
    [isCommentsEnabled] BOOLEAN NOT NULL,
    [isLikesVisible] BOOLEAN NOT NULL,
    [hasLiked] BOOLEAN NOT NULL,
    [hasEdit] BOOLEAN NOT NULL,
    [createdDate] TEXT NOT NULL,
    FOREIGN KEY([userId]) REFERENCES t_PartialUser([id]) ON DELETE CASCADE
);

CREATE TABLE t_PartialUser(
    [id] TEXT NOT NULL PRIMARY KEY,
    [name] TEXT NOT NULL
);

CREATE TABLE t_PartialUserAvatar(
    [id] TEXT NOT NULL PRIMARY KEY,
    [width] INTEGER NOT NULL,
    [height] INTEGER NOT NULL,
    [url] TEXT NOT NULL,
    [mimeType] TEXT NOT NULL,
    [partialUserId] TEXT NOT NULL,
    FOREIGN KEY([partialUserId]) REFERENCES t_PartialUser([id]) ON DELETE CASCADE
);

CREATE TABLE t_PostContentCandidate(
    [id] TEXT NOT NULL PRIMARY KEY,
    [width] INTEGER NOT NULL,
    [height] INTEGER NOT NULL,
    [url] TEXT NOT NULL,
    [mimeType] TEXT NOT NULL,
    [postContentId] TEXT NOT NULL,
    FOREIGN KEY([postContentId]) REFERENCES t_PostContent([id]) ON DELETE CASCADE
);

CREATE TABLE t_PostContent(
    [id] TEXT NOT NULL PRIMARY KEY,
    [postId] TEXT NOT NULL,
    FOREIGN KEY([postId]) REFERENCES t_Post([id]) ON DELETE CASCADE
);


CREATE TABLE t_User(
    [id] TEXT NOT NULL PRIMARY KEY,
    [name] TEXT NOT NULL,
    [fullName] TEXT NOT NULL,
    [biography] TEXT NOT NULL,
    [amountFollowing] INTEGER NOT NULL,
    [amountFollowers] INTEGER NOT NULL,
    [amountPosts] INTEGER NOT NULL,
    [isPrivate] BOOLEAN NOT NULL,
    [followedByViewer] BOOLEAN NOT NULL,
    [hasRequestedViewer] BOOLEAN NOT NULL,
    [followsViewer] BOOLEAN NOT NULL,
    [hasBlockedViewer] BOOLEAN NOT NULL,
    [blockedByViewer] BOOLEAN NOT NULL
);

CREATE TABLE t_UserAvatarCandidate(
    [id] TEXT NOT NULL PRIMARY KEY,
    [width] INTEGER NOT NULL,
    [height] INTEGER NOT NULL,
    [url] TEXT NOT NULL,
    [mimeType] TEXT NOT NULL,
    [userAvatarId] TEXT NOT NULL,
    FOREIGN KEY([userAvatarId]) REFERENCES t_UserAvatar([id]) ON DELETE CASCADE
);

CREATE TABLE t_UserAvatar(
    [id] TEXT NOT NULL PRIMARY KEY,
    [userId] TEXT NOT NULL,
    FOREIGN KEY([userId]) REFERENCES t_User([id]) ON DELETE CASCADE
);

CREATE TABLE t_SearchString(
    [id] TEXT NOT NULL PRIMARY KEY,
    [searchString] TEXT NOT NULL
);