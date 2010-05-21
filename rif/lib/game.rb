module Rif
  class Game
    attr_reader :map, :vocab, :entities, :rulebook, :turns
    
    attr_accessor :default_entity_class
    attr_accessor :starting_room
    
    def initialize
      @map = Map.new
      @vocab = Grammar::Vocab.default
      @entities = []
      @rulebook = Rulebook.new
      @turns = 0
      
      @default_entity_class = Entity
      @starting_room = "home"
      
      @parser = Grammar::SentenceParser.new(@vocab)
      @entity = nil
    end
    
    def prepare
      
      @entities << default_entity_class.new
      @entity = @entities[0]
    
      room_obj = @map[starting_room]
      raise "starting room '#{starting_room}' not found" unless room_obj
      @entity.room = room_obj
    
    end
    
    def handle_input(string)
      
      @messages = []
      
      sentences = @parser.parse(string)
      reduced_sentences = sentences.map { |s| s.reduce(@vocab) }
      
      reduced_sentences.each do |s|
        @entity.enqueue s
      end
      
      while @entity.busy?
        tick
      end
      
      @messages
    
    end
    
    def entity
      @entity
    end
    
    def room
      @entity.room
    end
    
    def active_entity
      @entity
    end
    
    def active_entity?(e)
      @entity == e
    end
    
  private
  
    def tick
      # deal with active entity first
      # if their next command doesn't constitute a turn, we don't tick
      # anyone else
      unless tick_entity(active_entity)
        return
      end
      
      @turns += 1
    
      @entities.each do |e|
        next if active_entity?(e)
        turn_used = false
        while !turn_used
          turn_used = tick_entity(e)
        end
      end
    end
    
    def tick_entity(e)
      if e.busy?
        command = Command.new(self, e, e.dequeue)
        e.room.rulebook.dispatch(command) if e.room
        rulebook.dispatch(command)
        if active_entity?(e)
          command.error "Sorry I don't understand" unless command.handled?
          @messages.concat(command.messages)
        end
        command.turn?
      else
        true
      end
    end
    
  end
end