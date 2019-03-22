#!/usr/local/bin/ruby
require 'bundler'
require 'clubhouse'
require 'date'

clubhouse_token = '<redacted>'

Clubhouse.default_client = Clubhouse::Client.new(clubhouse_token)
stories_in_dev = Clubhouse::Story.search({workflow_state_id:500000006, archived: false})
stale_stories = stories_in_dev.select { |story| Date.parse(story.updated_at) < Date.today - 7 }

counter = 0

stale_stories.each do |story|
  comment = Clubhouse::Comment.new(
    story_id: story.id,
    text: "This story has been in 'In Development' for over a week. Can you please: a) Update with the correct state (i.e. Backlog if it's on the shelf for now) or b) if you're actively working on it add a comment with an update? Thanks -- Clubhouse Nudge bot"
  )
  comment.save
  counter += 1
end

if counter > 1
  print "Commented on #{counter} stories\n"
else
  print "No stories to comment on\n"
end
