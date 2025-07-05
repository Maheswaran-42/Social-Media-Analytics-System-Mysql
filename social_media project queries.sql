create database social_media;
use social_media;
create table users(user_id int primary key auto_increment,username varchar(50) unique,email varchar(100)
unique,join_date date);
create table posts(
post_id int primary key auto_increment,
user_id int,
content text,
created_at datetime default current_timestamp,
constraint user_id_fk foreign key (user_id) references users(user_id));
Create table Likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references Users(user_id),
    foreign key (post_id) references Posts(post_id)
);
create table comments(
comment_id int primary key auto_increment,
user_id int,
post_id int,
comment_text text,
commented_at datetime default current_timestamp,
foreign key (user_id) references Users(user_id),
foreign key (post_id) references Posts(post_id)
);
create table followers(
follower_id int,
following_id int,
follow_date date,
primary key (follower_id, following_id),
foreign key (follower_id) references Users(user_id),
foreign key (following_id) references Users(user_id)
);
select * from users;
select * from posts;
select * from likes;
select * from followers;
select * from comments;

-- Get all usernames and their join dates.
select username,join_date from users;

-- Find all posts made by a specific user (user_id = 1).
select * from posts where user_id = 1;

-- Count total number of posts in the platform.
select count(*) from posts;

-- Find all comments on a specific post (post_id = 5).
select comment_text from comments where post_id = 5;

-- Get all likes made by a specific user (user_id = 1).
select * from likes where user_id = 1;

-- Find how many posts each user has made.
select user_id,count(*) as tot from posts group by user_id;

-- Get total comments on each post.
select post_id , count(*) as total from comments group by post_id;

-- Find the top 5 most liked posts.
select post_id ,count(*) as tot, post_id from likes group by post_id order by tot desc limit 5;

-- Find the top 5 users with the most posts.
select user_id,count(*) as tot from posts group by user_id order by tot desc limit 5;

-- Get the username and email for users who have posted something.
select us.username,us.email
from users us left outer join posts po
on us.user_id = po.user_id;

--  Find all comments with commenter’s username and the post ID.
select us.username , co.comment_text,co.post_id
from users us left join comments co
on us.user_id = co.user_id;

 -- List all likes with liker’s username and post content.
select us.username,p.content
from likes l right join users us
on us.user_id = l.user_id
join posts p
on p.post_id = l.post_id;

-- Get posts with their total number of likes and comments.
select p.post_id , count(distinct l.like_id) as total_like ,count(distinct c.comment_id) as total_comments
from posts p left join likes l
on p.post_id = l.post_id
left join comments c
on p.post_id  = c.post_id
group by p.post_id;

-- Find how many followers each user has.
select following_id, count(*) as total_followers 
from followers 
group by following_id ;

-- Find how many users each user is following.
select follower_id, count(*) as total_followers 
from followers 
group by follower_id ;

-- Find mutual followers (user pairs who follow each other).
select follower_id , following_id 
from followers 
where follower_id = following_id and 
following_id = follower_id;

-- Find posts made in the last 7 days.
select * from posts where created_at >=date_sub(now(),interval 7 day);

-- Find users who joined in the last month.
select * from users where join_date >=date_sub(now(),interval 1 month);

-- Find the user with the most followers.
select following_id , count(*) as total_followers from followers group by following_id
order by total_followers desc limit 1;

-- Find users who never posted anything.
select us.user_id,us.username 
from users us left join posts p
on us.user_id=p.user_id
where p.post_id is null;

-- List the 5 users who liked the most posts.
select user_id, count(*) as  total_likes
from likes
group by user_id
order by total_likes desc
limit 5;

-- Show all posts that have no likes.
select p.post_id ,p.user_id,p.content
from posts p left join likes l
on p.user_id = l.user_id
where l.like_id is null;

-- Find posts with more than 10 comments.
select p.post_id,c.comment_id
from posts p left join comments c
on p.user_id = c.user_id
where c.comment_id > 10;

-- Find the most active commenter (user with most comments).
select us.user_id, count(*) as most_com
from comments us group by us.user_id
order by most_com desc limit 1;

-- Show the 5 newest posts with username.
select us.username , p.content,p.post_id ,p.created_at
from posts p left join  users us 
on us.user_id =  p.user_id
order by p.created_at desc limit 5;

-- List all posts liked by a specific user (e.g., user_id = 10).
select p.post_id,p.content 
from likes l join posts p
on l.user_id = p.user_id
where l.user_id = 3;

-- Find users who follow more than 5 other users.
select follower_id , count(*) as follow
from followers 
group by follower_id having follow > 5;

-- Find users who have the most followers.
select following_id , count(*) as follow
from followers 
group by following_id 
order by follow desc ;




