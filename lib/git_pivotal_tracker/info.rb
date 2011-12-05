module GitPivotalTracker
  class Info < Base

    def run!
      return 1 if super

      unless story_id
        puts "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      puts "URL:           #{story.url}"
      puts "Story:         #{story.name}"
      puts "Description:   #{story.description}"

      notes = story.notes.all.collect(&:text).join("\n")
      puts "Comments:      #{notes}"

      return 0
    end
  end
end
