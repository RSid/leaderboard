require 'sinatra'
require 'shotgun'
require 'CSV'


def get_games (file_name)
  @games=[]

  CSV.foreach(file_name, :headers => true) do |row|
    homet=row["home_team"]
    awayt=row["away_team"]
    homes=row["home_score"]
    aways=row["away_score"]

    @games.push( {:Hometeam => homet, :Awayteam => awayt, :Homescore => homes, :Awayscore =>aways} )
  end

  @games
end


def get_records (file_name)
  games=get_games(file_name)
  wins=[]
  losses=[]
  team_names=[]
  @records=[]

  games.each do |game|
    team_names<<game[:Hometeam]
    team_names<<game[:Awayteam]
    if game[:Homescore].to_i>game[:Awayscore].to_i
      wins<< game[:Hometeam]
      losses<<game[:Awayteam]
    elsif game[:Homescore].to_i<game[:Awayscore].to_i
      wins<< game[:Awayteam]
      losses<<game[:Hometeam]
    end
  end

  team_names.uniq.each do |team|
    @records<<[team,{:Team=>team,:Wins=>wins.count(team),:Losses=>losses.count(team)}]
  end
  @records=@records.sort_by{|arr| [arr[1][:Wins],-arr[1][:Losses]]}.reverse

  @records.each do |record|
    games.each do |game|
      if record[0]==game[:Hometeam] || record[0]==game[:Awayteam]
        record<<[game[:Hometeam],game[:Homescore],game[:Awayteam],game[:Awayscore]]
      end
    end
  end

  @records
end




get '/leaderboard' do
  @records=get_records('nfl.csv')

  erb :index
end

get '/leaderboard/:team' do
  @team = params[:team]
  @records=get_records('nfl.csv')

  erb :team
end
