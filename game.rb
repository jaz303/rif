require 'rif/rif'

room :bedroom do |r|
  r.name 'Bedroom'
  r.description <<-DESC
    This is the description of the bedroom
  DESC
  r.exits({:north => :hallway})
  r.starting_room
end

room :hallway do |r|
  r.name 'Hallway'
  r.description <<-DESC
    This is the description of the hallway
  DESC
  r.exits({:south => :bedroom, :east => :kitchen})
end

room :kitchen do |r|
  r.name 'Kitchen'
  r.description <<-DESC
    This kitchen is grubby! Pots and pans everywhere!
  DESC
  r.exits({:west => :hallway})
end



Rif::Runner.new(game).run