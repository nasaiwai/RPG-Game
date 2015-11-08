#==============================================================================
#  * Followers
#------------------------------------------------------------------------------
#  This class handles followers' visibility. It removes a character from the
#  screen if the character dies. The character reappears on the screen if 
#  the character comes back to life again.
#------------------------------------------------------------------------------
#  @author: Nasa Iwai
#  @date: October 15th, 2015 
#==============================================================================

module BattleManager
    
  class << BattleManager

   #------------------------------------------------------------------------
   # alias method: battle_end_updated
   # This method handles new batttle endings
   #------------------------------------------------------------------------

   alias battle_end_updated battle_end
    def battle_end(result)
      $game_player.refresh
      battle_end_updated(result)
    end
  end
  
end


class Scene_Menu < Scene_MenuBase

  #-------------------------------------------------------------------------
  # alias method: return_scene_updated
  # this method handles new scene menu
  #-------------------------------------------------------------------------

  alias return_scene_updated return_scene
  def return_scene
    $game_player.refresh
    return_scene_updated
  end
  
end


class Game_Follower < Game_Character

  #-------------------------------------------------------------------------
  # method: get_x
  # method: get_y
  # method: get_d
  # this class handles followers' position on the screen
  #-------------------------------------------------------------------------

  def get_x
    return @x
  end
  
  def get_y
    return @y
  end
  
  
  def get_d
    return @direction
  end
  
end


 
class Game_Party < Game_Unit

  #------------------------------------------------------------------------
  # method: move_dead_leader
  # method: move_dead_leader_battle_end
  # This class switches a dead leader and a alive follower 
  # This also helps to remove a dead leader from the screen
  #------------------------------------------------------------------------
  
  def move_dead_leader
    next_alive_member = @actors.index {|i| p i; $game_actors[i].alive?}
    swap_order(0, next_alive_member)
    #swap_order(1, 2)
    #swap_order(2, 3)
  end
 
  alias :move_dead_leader_battle_end :on_battle_end
  def on_battle_end
    move_dead_leader_battle_end
    move_dead_leader unless leader.alive?
  end
end


class Game_Party < Game_Unit
 
  def move_dead_members
    alive_members = @actors.index {|i| p i; $game_actors[i].alive?}
    swap_order(0, alive_members)
  end
 
  alias :move_dead_members_battle_end :on_battle_end
  def on_battle_end
    move_dead_members_battle_end
    move_dead_members unless @actors.index {|i| p i; $game_actors[i].alive?}
  end
end


class Game_Followers
  
  attr_reader   :leader

  #------------------------------------------------------------------------
  # alias method init_updated
  # This method initialize leader
  #------------------------------------------------------------------------
  
  alias init_updated initialize
  def initialize(leader)
    @leader = leader
    init_updated(leader)
  end

  #------------------------------------------------------------------------
  # alias method: refresh_updated
  # This method removes dead members from the screen
  #------------------------------------------------------------------------
  
  alias refresh_updated refresh
  def refresh
    cDirection = @data.pop
    x = cDirection.get_x
    y = cDirection.get_y
    d = cDirection.get_d
    @data = []
    index = 1
    leader_not_established = true
  if $game_party.members.length == 4
    while index < $game_party.members.length
      if leader_not_established
        @data.push(Game_Follower.new(index, @leader)) unless $game_party.members[index].hp < 1
        leader_not_established = false unless $game_party.members[index].hp < 1        
      else
        @data.push(Game_Follower.new(index, @data[-1])) unless $game_party.members[index].hp < 1        
      end
      index = index + 1
    end
  end
    synchronize(x, y, d)
    refresh_updated
  end
  
end
