module Rif
  class Thing
    def moveable?
      false
    end
    
    def weight
      1.0 / 0.0
    end
    
    def entity?
      false
    end
    
    def object?
      false?
    end
  end
  
  class Object < Thing
    attr_accessor :name
    attr_accessor :adjectives
    
    def initialize(noun, attributes = {})
      attributes.each { |k, v| send(:"#{k}=", v) }
      @noun = noun.to_s
    end
    
    def object?
      true
    end
  end
  
  class FixedObject < Object
  end
  
  class MoveableObject < Object
    def moveable?
      true
    end
    
    def weight
      @weight || 1
    end
  end
  
  class Entity < Thing
    attr_accessor :room
    
    def initialize
      @queue = []
      @inventory = []
    end
    
    def room=(room)
      @room.exited(self) if @room
      @room = room
      @room.entered(self) if @room
    end
    
    def enqueue(sentence)
      @queue << sentence
    end
    
    def busy?
      ! @queue.empty?
    end
    
    def dequeue
      @queue.shift
    end
    
    def take(thing)
      if thing.moveable?
        @inventory << thing
      else
        # TODO: raise
      end
    end
    
    def entity?
      true
    end
  end
end