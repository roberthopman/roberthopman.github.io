require_relative "roman.rb"

r = Roman.new(1)
fail "'I' expected but got #{r.to_s}" if r.to_s != 'I'
