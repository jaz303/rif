class String
  def deindent
    indent = split("\n").inject(1000) { |min,line|
      (line.strip.length == 0) ? min : [/^ */.match(line)[0].length, min].min
    }
    gsub(/^#{' ' * indent}/, '')
  end
end
