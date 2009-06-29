class SentenceParser
  SKIP = %w(,)
  SEPARATORS = %w(. ! ? then)
  
  def self.parse(string)
    new.parse(string)
  end
  
  def parse(string)
    @tokens = tokenize(string)
    reset
    parse_sentences
  end
  
private

  def curr
    @curr
  end

  def reset
    accept
  end
  
  def accept(token = nil)
    raise if token && token != curr
    @curr = @tokens.shift
  end
  
  def eos?
    curr.nil?
  end
  
  def word?
    !skippable? && !separator?
  end
  
  def skippable?
    SKIP.include?(curr)
  end
  
  def separator?
    SEPARATORS.include?(curr)
  end

  def parse_sentences
    sentences = []
    if not eos?
      sentences << parse_sentence
      while separator?
        while separator?
          accept
        end
        sentences << parse_sentence
      end
    end
    sentences
  end
  
  def parse_sentence
    sentence = Sentence.new
    while curr != ')' && !separator? && !eos?
      if curr == '('
        sentence << parse_sub_sentence
      elsif word?
        sentence << curr
        accept
      elsif skippable?
        accept
      end
    end
    sentence
  end
  
  def parse_sub_sentence
    accept '('
    sentence = parse_sentence
    accept ')'
    sentence
  end

  def tokenize(string)
    sanitise(string).split(/[ ]+/)
  end

  def sanitise(string)
    string.gsub(/([()"',.?!])/, ' \\1 ').strip
  end
end
