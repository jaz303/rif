require 'set'

module Rif
  class Map
    def initialize
      @zone_stack = []
      @rooms      = {}
    end
    
    def [](name)
      @rooms[name.to_s]
    end
    
    def zone(name)
      @zone_stack << name.to_s
      begin
        yield
      ensure
        @zone_stack.pop
      end
    end
    
    def room(name)
      @zone_stack << name
      room = Room.new(self, @zone_stack.dup)
      @rooms[room.name] = room
      @zone_stack.pop
      yield room
    end
  end
  
  class Room
    attr_reader :map, :name, :rulebook
    
    def initialize(map, path)
      @map, @path, @name, @portals = map, path, path.join('.'), {}
      @locals = {}
      @things = Set.new
      @rulebook = Rulebook.new
      @title, @description = '', ''
    end
    
    def [](k)
      @locals[k]
    end
    
    def []=(k,v)
      @locals[k] = v
    end
    
    # This is horrid, should be moved to something like
    # map.resolve_room(name, relative_to = nil)
    def find_room(room_name)
      if room_name[0..0] == '.'
        @map[room_name[1..-1]]
      else
        p = @path.dup
        p.pop
        p += room_name.split('.')
        r = @map[p.join('.')]
        r || @map[room_name]
      end
    end
    
    def title(new_title = nil)
      if new_title.nil?
        @title
      else
        @title = new_title
      end
    end
    
    def description(new_description = nil)
      if new_description.nil?
        @description
      else
        @description = new_description.deindent
      end
    end
    
    def portal(direction, room, options = {})
      p = Portal.new(self, direction, room, options)
      @portals[p.direction] = p
    end
    
    def find_portal(direction)
      @portals[Portal.normalize_direction(direction)]
    end
    
    def exits
      @portals.keys
    end
    
    def exit_names
      exits.map { |e| Portal::DIRECTION_NAMES[e] }.sort
    end
    
    def portals(ps, options = {})
      ps.each { |k,v| portal(k, v, options) }
    end
    
    def exited(entity)
      @things.add(entity)
    end
    
    def entered(entity)
      @things.delete(entity)
    end
    
    def entities
      @things.select { |t| t.entity? }.to_a
    end
    
    def rule(pattern, &block)
      rulebook.rule(pattern, &block)
    end
  end
  
  class Portal
    def self.normalize_direction(d)
      DIRECTIONS[d.to_sym]
    end
    
    DIRECTION_NAMES = {
      :n            => 'north',
      :ne           => 'northeast',
      :e            => 'east',
      :se           => 'southeast',
      :s            => 'south',
      :sw           => 'southwest',
      :w            => 'west',
      :nw           => 'northwest',
      :u            => 'up',
      :d            => 'down'
    }
    
    DIRECTIONS = {
      :n            => :n,
      :north        => :n,
      :s            => :s,
      :south        => :s,
      :w            => :w,
      :west         => :w,
      :e            => :e,
      :east         => :e,
      :ne           => :ne,
      :north_east   => :ne,
      :northeast    => :ne,
      :se           => :se,
      :south_east   => :se,
      :southeast    => :se,
      :sw           => :sw,
      :south_west   => :sw,
      :southwest    => :sw,
      :nw           => :nw,
      :north_west   => :nw,
      :northwest    => :nw,
      :u            => :u,
      :up           => :u,
      :d            => :d,
      :down         => :d
    }
    
    attr_reader :from, :direction, :to
    
    def initialize(from, direction, to, options = {})
      @from             = room_name(from)
      @direction        = self.class.normalize_direction(direction)
      @to               = room_name(to)
      @attenuation      = (options[:attenuation] || 1.0).to_f
      
      @blocked, @blocked_message = false, 'Blocked'
      if options.key?(:blocked)
        @blocked = !!options[:blocked]
        @blocked_message = options[:blocked] if options[:blocked].is_a?(String)
      end
    end
    
    def blocked?
      @blocked
    end
    
    def blocked!(msg = nil)
      @blocked_message = msg unless msg.nil?
      @blocked = true
    end
    
    def unblocked!
      @blocked = false
    end
    
    def toggle_blocked(msg = nil)
      if blocked?
        unblocked!
      else
        blocked!(msg)
      end
    end
      
  private
    def room_name(room)
      room.is_a?(String) ? room : room.name
    end
  end
end