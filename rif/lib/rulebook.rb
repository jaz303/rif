module Rif
  
  # Rules are specified like this:
  # go $:motion
  # $:verb $:noun
  #
  # If you have more than one of a part of speech you can do named captures:
  #
  # $noun_1:noun $noun_2:noun

  class Matcher
    def self.try_match(sentence, node)
      match_data = MatchData.new
      sentence.each do |word|
        node = node.try_match(word, match_data)
        break if node === false
      end
      node === true ? match_data : false
    end
    
    def initialize
      @next = true
    end
    
    def next=(matcher)
      @next = matcher
    end
  end

  class LiteralMatcher < Matcher
    def initialize(literal)
      super()
      @literal = literal
    end
    
    def try_match(word, match_data)
      if word.text == @literal
        @next
      else
        false
      end
    end
  end
  
  class TypeMatcher < Matcher
    def initialize(type, capture)
      super()
      capture = type if capture.nil? || capture.length == 0
      @type, @capture = type.to_sym, capture.to_sym
    end
    
    def try_match(word, match_data)
      if word.type == @type
        match_data[@capture] = word
        @next
      else
        false
      end
    end
  end
  
  class MatchData
    def []=(k, v)
      @captures[k.to_sym] = v.to_s
    end
    
    def [](k)
      @captures[k]
    end
    
    def initialize
      @captures = {}
    end
  end
  
  class Rule
    def initialize(pattern, &block)
      @pattern = pattern
      @node = parse_matcher(pattern)
      @block = block
    end
    
    def process(command)
      return if command.handled?
      return unless match_data = Matcher.try_match(command.sentence, @node)
      @block.call(command, match_data)
    end

  private
  
    def parse_matcher(pattern)
      start_node = node = nil
      pattern.strip.split(/\s+/).each do |b|
        if b =~ /^[a-z0-9_-]+$/i
          new_node = chain_node(node, LiteralMatcher.new(b))
        elsif b =~ /^\$([a-z_]+)?\:([a-z_]+)$/i
          new_node = chain_node(node, TypeMatcher.new($2, $1))
        else
          raise "parse error: don't know what to do with #{b}"
        end
        node = new_node
        start_node = node if start_node.nil?
      end
      start_node
    end
    
    def chain_node(node, new_node)
      node.next = new_node if node
      new_node
    end
  end
  
  class Rulebook
    def initialize
      @rules = []
    end
    
    def rule(pattern, &block)
      @rules << Rule.new(pattern, &block)
    end
    
    def dispatch(command)
      @rules.each { |r| r.process(command) }
    end
  end
end