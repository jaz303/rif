module Rif
  class Parser
    def initialize(commands)
      @commands = commands
    end
    
    def parse_and_run(cmd)
      cmd.strip.split(/\s+/).each do |t|
        run(t)
      end
    end
    
    def run(cmd)
      puts @commands.send(cmd.to_sym)
    end
  end
end