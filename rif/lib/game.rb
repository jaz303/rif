module Rif
  class Game
    attr_reader :map, :vocab, :entities, :rulebook
    
    attr_accessor :default_entity_class
    attr_accessor :starting_room
    
    def initialize
      @map = Map.new
      @vocab = Grammar::Vocab.default
      @entities = []
      @rulebook = Rulebook.new
      
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
    
    def active_entity?(e)
      @entity == e
    end
    
  private
  
    def tick
      @entities.each do |e|
        if e.busy?
          command = Command.new(self, e, e.dequeue)
          e.room.rulebook.dispatch(command) if e.room
          rulebook.dispatch(command)
          if active_entity?(e)
            @messages.concat(command.messages)
          end
        end
      end
    end
  end
end