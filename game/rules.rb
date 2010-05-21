rule "$:command" do |c, m|
  c.no_turn!
end

rule "turns" do |c, m|
  c.info "You have taken #{c.game.turns} turn(s)"
  c.handled!
end

rule "look" do |c, m|
  puts "i'm looking!"
  c.handled!
end

rule "exits" do |c, m|
  exits = c.room.exit_names
  if exits.empty?
    c.error "There is no escape"
  else
    c.info "Possible exits: #{exits.join(', ')}"
  end
  c.handled!
end

rule "inventory" do |c, m|
  # dump inventory
  c.handled!
end


rule "go $direction:motion" do |c, m|
  if portal = c.room.find_portal(m[:direction])
    c.entity.room = c.room.find_room(portal.to)
  else
    c.error "You can't go that way"
  end
  c.handled!
end