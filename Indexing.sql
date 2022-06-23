ALTER TABLE `user` ADD INDEX `full_name` (`first_name`,`last_name`);
ALTER TABLE `contacts` ADD INDEX `contacts_idx_user_id` (`user_id`);
ALTER TABLE `status` ADD INDEX `status_idx_posted_by_status_id` (`posted_by`,`status_id`);
ALTER TABLE `status_views` ADD INDEX `status_views_idx_user_id` (`user_id`);
ALTER TABLE `calls` ADD INDEX `calls_idx_call_details` (`caller_id`,`callee_id`,`timestamp`);