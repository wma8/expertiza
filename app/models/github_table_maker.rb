class GithubTableMaker

  def self.get_table_data(params)
    members = params[:team].users.map{ |u| {:name => u.name, :github_id => u.github_id} }
    members.each do |member|
      member[:commits_count] = 0
      member[:additions] = 0
      member[:deletions] = 0
      member[:timeline] = nil
      member[:commits] = []
      if !member[:github_id].nil?
        params[:commits].each do |commit|
          if member[:github_id] == commit[:user_id]
            member[:commits_count] += 1
            member[:additions] += commit[:lines_added].to_i
            member[:deletions] += commit[:lines_deleted].to_i
            if member[:timeline].nil?
              member[:timeline] = [commit[:commit_date], commit[:commit_date]]
            else
              member[:timeline][1] = commit[:commit_date]
            end
            member[:commits].push(commit)
          end
        end
      end
    end
  end

  def self.to_graph(table_metrics)
    if ! table_metrics.nil? && ! table_metrics.empty?
      result = []
      table_metrics.each do |member|
        if ! member[:github_id].nil?
          result.push([member[:name], member[:additions].to_i + member[:deletions].to_i])
        end
      end
      result.unshift(["Name", "Total Changes"])
    else 
      ["Name", "Total Changes"]
    end
  end

end