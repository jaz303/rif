
THE_GAME = Game.new

def game
  THE_GAME
end

def room(room_id)
  room = Room.new(room_id)
  game.add_room(room.id, room)
  yield room if block_given?
  room
end