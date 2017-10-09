class GithubTableMaker
  
  attr_accessor :members
  attr_accessor :commits_count
  attr_accessor :delta
  attr_accessor :timeline
  attr_accessor :commits

  def initialize(params)
    @members = Array.new
    @commits_count = Array.new
    @delta = Array.new
    @timeline = Array.new
    @commits = Array.new
    fill_data(params["commits"])
  end

  private

  def fill_data(commits)
    commits.each do |commit|
      if ! @members.include?(commit[:name])
        @members.push(commit[:name])
        @commits_count.push(1)
        @delta.push([commit[:stats][:additions], commit[:stats][:deletions]])
        @timeline.push([commit[:date], commit[:date]])
        @commits.push([commit])
      else
        i = @members.index(commit[:name])
        @commits_count[i] += 1
        @delta[i][0] += commit[:stats][:additions]
        @delta[i][1] += commit[:stats][:deletions]
        @timeline[i][1] = commit[:date]
        @commits[i].push(commit)
      end
    end
  end

end