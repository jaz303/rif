require 'readline'

module Rif
  module Runners
    class ConsoleRunner
      include Readline

      def initialize(game)
        @game = game
      end

      def run
        present
        while cmd = readline('> ')
          break if cmd == 'quit'
          response = @game.handle_input(cmd)
          unless response.empty?
            puts
            response.each do |r|
              color = case r.first
                when :success then "\033[32m"
                when :error then "\033[31m"
                else ''
              end
              puts "\033[1m" + color + r.last + "\033[0m"
            end
          end
          puts
          present
        end
      end

    private

      def present
        puts "\033[1m" + @game.room.title + "\033[0m"
        puts
        puts @game.room.description
        puts
      end
    end
  end
end