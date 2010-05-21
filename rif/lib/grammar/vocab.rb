module Rif
  module Grammar
    class Vocab
      def self.default
        v = new
        v.instance_eval do
          motion :n, :ne, :e, :se, :s, :sw, :w, :nw, :u, :d
          synonym :n, :north
          synonym :ne, :northeast
          synonym :e, :east
          synonym :se, :southeast
          synonym :s, :south
          synonym :sw, :southwest
          synonym :w, :west
          synonym :nw, :northwest
          synonym :u, :up
          synonym :d, :down
          
          speech :say, :shout, :whisper, :scream
        
          verb :get
          synonym :get, :take
        
          command :inventory
          synonym :inventory, :i
          
          command :look
          synonym :look, :l
          
          command :exits
          command :turns
        end
        v
      end
    
      def initialize
        @type_map = {}
      end
    
      # noun, adverb, adjective and verb are self-explanatory
      # motion = verb of motion, e.g. to move character between locations
      # command = in-game command, e.g. "look", "inventory"
      %w(noun adverb adjective verb motion speech command).each do |type|
        class_eval <<-CODE
          def #{type}(*words)
            add(:#{type}, *words)
          end
        
          def #{type}?(word)
            type(word) == :#{type}
          end
        CODE
      end
    
      def add(word_type, *words)
        [words].flatten.map { |w| w.to_s }.each do |word|
          existing_type = type(word)
          if existing_type.nil?
            @type_map[word] = word_type
          elsif existing_type != word_type
            raise "'#{word}' already registered with type '#{existing_type}'"
          end
        end
      end
    
      # define any number of synonyms for a given word
      def synonym(existing_word, *synonyms)
        existing_word = existing_word.to_s
        raise "'#{existing_word}' is not in the vocabulary" if type(existing_word).nil?
        reduced_form = reduce(existing_word)
        [synonyms].flatten.each do |syn|
          syn = syn.to_s
          existing_definition = @type_map[syn]
          if existing_definition.nil?
            @type_map[syn] = reduced_form
          elsif existing_definition != reduced_form
            raise "'#{syn}' is already defined and is incompatible as a synonym of #{existing_word}"
          end
        end
      end
    
      # returns the type of a word, works for synonyms too
      def type(word)
        type_of_word = @type_map[word]
        while String === type_of_word
          type_of_word = @type_map[type_of_word]
        end
        type_of_word
      end
    
      # resolve a possible synonym to its root definition
      def reduce(word)
        definition = @type_map[word]
        case definition
        when Symbol
          word
        when String
          reduce(definition)
        when nil
          nil
        end
      end
    end
  end
end
