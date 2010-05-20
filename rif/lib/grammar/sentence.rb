module Rif
  module Grammar
    class Sentence
      def initialize(words = [])
        @words = words
      end
      
      def each
        @words.each { |w| yield w }
      end
  
      def words
        @words.dup
      end
  
      def <<(word)
        @words << word
      end
      
      def to_s
        '"' + @words.map { |w| w.to_s }.join(' ') + '"'
      end
      
      def inspect
        '(' + @words.map { |w| w.inspect }.join(' ') + ')'
      end
      
      def reduce(vocab)
        Sentence.new(@words.map { |w| w.reduce(vocab) })
      end
    end
  end
end