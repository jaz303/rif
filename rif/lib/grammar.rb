class String
  def to_matcher
    self.gsub(/\$[a-z]+/) { |m| "foo" }
  end
end

class Matcher
  def initialize(pattern)
    
  end
  
  def matches?(string)
    
  end
end

class Handler
  def initialize(pattern, block)
    @matcher, @block = pattern.to_s.to_matcher, block
  end
  
  def call(state, string)
    if @matcher.matches?(string)
      @block.call(state)
      true
    else
      false
    end
  end
end

class Rewrite
  def initialize(pattern, result)
    @matcher, @result = pattern.to_s.to_matcher, result
  end
  
  def call(string)
    if @matcher.matches?(string)
      # do rewrite
    else
      nil
    end
  end
end

class Grammar
  def initialize
    @rewrites, @handlers = [], []
  end
  
  def rewrite(pattern, result)
    @rewrites << Rewrite.new(pattern, result)
  end
  
  def handle(pattern, &block)
    @handlers << [pattern, block]
  end
  
  def process(state, string)
    string = rewrite_string(string)
    @handlers.each do |handler|
      if handler.call(state, string)
        return true
      end
    end
    false
  end
  
  def rewrite_string(string)
    @rewrites.each do |rewrite|
      rewritten_string = rewrite.call(string)
      unless rewritten_string.nil?
        string = rewrite_string(rewritten_string)
        break
      end
    end
    string
  end
end

puts "$adjective ($noun+) $verb".to_matcher