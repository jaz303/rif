module Rif
  @@active = nil

  def self.new_game!
    @@active = Game.new
  end

  def self.active_game
    @@active
  end
end

%w(
  core_extensions
  grammar/word
  grammar/vocab
  grammar/sentence
  grammar/sentence_parser
  rulebook
  command
  things
  map
  game
  game_loader
  global_helpers
  runners/console_runner
).each do |f|
  require File.join(File.dirname(__FILE__), 'lib', f)
end
