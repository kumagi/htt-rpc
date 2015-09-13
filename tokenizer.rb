def tokenize(src)
  src
    .gsub(/\/\/.*\n/, "")
    .gsub(/\\*.*\*\//m, "")
    .split(/\s+/)
    .map{|m| m.split(/(,|;|\/|\(|\)|{|})/)}
    .flatten
    .reject{|s| s.empty? }
end
