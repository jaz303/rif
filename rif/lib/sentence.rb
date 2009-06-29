class Sentence
  def initialize
    @words = []
  end
  
  def words
    @words.dup
  end
  
  def <<(word)
    @words << word
  end
end
