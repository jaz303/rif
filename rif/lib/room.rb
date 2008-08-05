class Room
  def self.sanitise_id(id)
    id.to_s.strip
  end
  
  def initialize(id)
    @id = self.class.sanitise_id(id)
  end
  
  def id
    @id
  end
  
  def name(name = nil)
    @name = name unless name.nil?
    @name
  end
  
  def description(description = nil)
    @description = description unless description.nil?
    @description
  end
  
  def exits(exits = nil)
    unless exits.nil?
      @exits = {}
      exits.each { |x,r| @exits[x.to_s] = r }
    end
    @exits
  end
  
  def starting_room
    @starting_room = true
  end
  
  def starting_room?
    !! @starting_room
  end
end