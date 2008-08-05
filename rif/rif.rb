%w(
  room
  commands
  game
  runner
  state
  parser
  rif
).each do |f|
  require File.join(File.dirname(__FILE__), 'lib', f)
end