#!/usr/bin/env ruby

require 'tracker_api'

class ProjectCollection
	def self.build(project_ids)
		client = TrackerApi::Client.new(token: ENV["BOSH_NOTES_TRACKER_TOKEN"])
		ProjectCollection.new(project_ids, client)
	end

	def initialize(project_ids, client)
		@project_ids = project_ids
		@client = client
	end

	def sorted
		@project_ids.map { |id| @client.project(id) }
	end

	def print_md
		colors = {
			red: color_square("a72039"),
			green: color_square("629100"),
			orange: color_square("f39300"),
			white: color_square("ffffff"),
			blue: color_square("8bb1e0"),
		}.freeze

		state_to_text = {
			"delivered" => colors[:green],
			"finished" => colors[:orange],
			"started" => colors[:blue],
			"rejected" => colors[:red],
			"planned" => "",
			"unstarted" => "",
		}.freeze

		projects = sorted

		puts "# Projects\n\n"
		projects.each do |project|
      puts "- [#{project.name}](https://www.pivotaltracker.com/projects/#{project.id})"
    end

    puts "# Stories\n\n"
    projects.each do |project|
      puts "## [#{project.name}](https://www.pivotaltracker.com/projects/#{project.id})\n\n"

      # https://www.pivotaltracker.com/help/api/rest/v5#top
      # accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled

      %w(delivered finished started rejected planned unstarted).each do |state|
      	stories = project.stories(with_state: state)
      	has_more_stories = false

      	if (state == "planned" || state == "unstarted") && stories.size > 10
      		stories = stories[0...10]
      		has_more_stories = true
      	end

      	puts "---" if state == "planned"

				stories.each do |story|
					puts "- #{state_to_text[state]} #{story.name} [link](https://www.pivotaltracker.com/story/show/#{story.id})"
				end

				puts "- ..." if has_more_stories
      end

      puts ""
    end
  end

  private

  def color_square(hex)
  	"![img](https://placehold.it/15/#{hex}/000000?text=+)"
  end
end

wanted_project_ids = [
	956238,  # CF BOSH [DNS]
	2139998, # CF BOSH [Links API]
	2132440, # CF BOSH [Hotswap]
	2132441, # CF BOSH
	1133984, # CF BOSH CPI
	1954971, # CF BOSH Extended Team
	2140000, # CF BOSH [Interviews]
	2110693, # BOSH vSphere CPI
	1456570, # CF BOSH OpenStack CPI
]

ProjectCollection.build(wanted_project_ids).print_md
