-- Note: Database name is overriden with env vars in the flask cli command
CREATE DATABASE IF NOT EXISTS {0};

USE {0};

CREATE TABLE IF NOT EXISTS `comments` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `content` TEXT NOT NULL,
    `post_id` BIGINT UNSIGNED  NOT NULL,
    `user_id` BIGINT UNSIGNED  NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS `posts` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `content` TEXT NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS `shares` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `post_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS `likes` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED  NOT NULL,
    `post_id` BIGINT UNSIGNED  NULL,
    `comment_id` BIGINT UNSIGNED NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS `followers` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `follower_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE posts ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (`user_id`) REFERENCES users(`id`);
ALTER TABLE followers ADD CONSTRAINT followers_follower_id_foreign FOREIGN KEY(`follower_id`) REFERENCES users(`id`);
ALTER TABLE followers ADD CONSTRAINT followers_user_id_foreign FOREIGN KEY(`user_id`) REFERENCES users(`id`);

ALTER TABLE comments ADD CONSTRAINT comments_post_id_foreign FOREIGN KEY(`post_id`) REFERENCES posts(`id`);
ALTER TABLE comments ADD CONSTRAINT comments_user_id_foreign FOREIGN KEY (`user_id`) REFERENCES users(`id`);

ALTER TABLE shares ADD CONSTRAINT shares_post_id_foreign FOREIGN KEY(`post_id`) REFERENCES posts(`id`);
ALTER TABLE shares ADD CONSTRAINT shares_user_id_foreign FOREIGN KEY(`user_id`) REFERENCES users(`id`);

ALTER TABLE likes ADD CONSTRAINT likes_post_id_foreign FOREIGN KEY(`post_id`) REFERENCES posts(`id`);
ALTER TABLE likes ADD CONSTRAINT likes_user_id_foreign FOREIGN KEY(`user_id`) REFERENCES users(`id`);
ALTER TABLE likes ADD CONSTRAINT likes_comment_id_foreign FOREIGN KEY(`comment_id`) REFERENCES comments(`id`);
