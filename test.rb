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

def get_team_info(file_name)
  games=get_games(file_name)
  team_names=[]
  team_info=[]

  games.each do |game|
    team_names<<game[:Hometeam]
    team_names<<game[:Awayteam]
  end
  team_names=team_names.uniq


    games.each do |game|
      team_names.each do |name|
      if game[:Hometeam]==name || game[:Awayteam]==name
        team_info<<{:Suprateam=>name,:Hometeam=>game[:Hometeam],:Awayteam=>game[:Awayteam]}
      end
    end
  end
  team_info
end

def get_team_names(file_name)
  games=get_games(file_name)
  team_names=[]

  games.each do |game|
    team_names<<game[:Hometeam]
    team_names<<game[:Awayteam]
  end
  team_names.uniq
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
    else
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

def get_losses (file_name,team_name)
  games=get_games(file_name)
  losses=[]

  games.each do |game|
    if game[:Homescore].to_i<game[:Awayscore].to_i
      losses<< game[:Hometeam]
    else
      losses<< game[:Awayteam]
    end
  end
  losses.count(team_name)
end

#print get_games("nfl.csv")
# puts
#print get_team_info('nfl.csv')
print get_records("nfl.csv")
# puts
# print get_losses("nfl.csv","Patriots")
