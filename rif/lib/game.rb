class Game
  
  def initialize
    @rooms = {}
  end
  
  def starting_room
    @rooms.find { |r| r.starting_room? }
  end
  
  def rooms
    @rooms
  end
  
  def add_room(id, room)
    @rooms[id] = room
  end
  
end