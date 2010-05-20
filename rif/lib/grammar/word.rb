module Rif
  module Grammar
    class Word
      attr_reader :text, :type
      
      def initialize(text, type)
        @text, @type = text, type
      end
      
      def to_s
        text
      end
      
      def inspect
        "#{text}:#{type || 'unknown'}"
      end
      
      def reduce(vocab)
        if type.nil?
          self
        else
          Word.new(vocab.reduce(text), type)
        end
      end
    end
  end
end