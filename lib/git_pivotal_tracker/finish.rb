module GitPivotalTracker
  class Finish < Base

    def run!
      return 1 if super

      unless story_id
        puts "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      if options[:rebase]
        puts "Fetching origin and rebasing #{current_branch}"
        log repository.git.checkout({:raise => true}, integration_branch)
        log repository.git.pull({:raise => true})
        log repository.git.rebase({:raise => true}, integration_branch, current_branch)
      end

      puts "Merging #{current_branch} into #{integration_branch}"
      log repository.git.checkout({:raise => true}, integration_branch)

      merge_options = {:raise => true}
      if options[:fast_forward]
        merge_options[:no_ff] = true
      else
        merge_options[:ff_only] = true
      end
      log repository.git.merge(merge_options, current_branch)

      puts "Pushing #{integration_branch}"
      log repository.git.push({:raise => true}, 'origin', integration_branch)
    rescue Grit::Git::CommandFailed => e
      puts "git error: #{e.err}"
      return 1
    end

    private

    def finished_state
      story.story_type == "chore" ? "accepted" : "finished"
    end

    def delete_current_branch
      puts "Deleting #{current_branch}"
      log repository.git.branch({:raise => true, :d => true}, current_branch)
    end
  end
end
