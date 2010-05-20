rule "go $direction:motion" do |c, m|
  if portal = c.room.find_portal(m[:direction])
    c.entity.room = c.room.find_room(portal.to)
  else
    c.error "You can't go that way"
  end
  c.handled!
end