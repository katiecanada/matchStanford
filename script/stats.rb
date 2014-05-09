def crushed
  choicesEdges = []
  choosers = []

  users = User.all
  users.each do |u|
    choices = u.choices
    if choices.nil? or choices.blank? then
      choices = "[]"
    end

    choicesArray = JSON.parse(choices)
    if choicesArray.length > 0 then
      choosers.append(u.username)

      choicesArray.each do |i|
        fromu = User.find(i).username
        choicesEdges.append({:from => u.username, :to => fromu})
      end
    end
  end

  choosers.uniq!
  choicesEdges.uniq!

  chosen = []
  mutuals = []

  choicesEdges.each do |edge|
    chosen.append(edge[:to])
    choicesEdges.select { |e| e[:from] == edge[:to] && e[:to] == edge[:from] }.each do |m|
      m2 = m
      if (m[:to] <=> m[:from]) < 0 then
        m2 = {:from => m[:to], :to => m[:from]}
      end
      mutuals.append m2
    end
  end

  mutuals.uniq!
  #pp mutuals

  # Remove reflexive choices
  mutuals_legit = mutuals.select { |e| e[:from] != e[:to] }

  # Get unique people matched
  matched = []
  mutuals_legit.each do |pair|
    matched.append pair[:from]
    matched.append pair[:to]
  end
  matched.uniq!

  agg = {}
  choicesEdges.each do |edge|
    if !agg[edge[:to]] then
      agg[edge[:to]] = 1
    else
      agg[edge[:to]] += 1
    end
  end

  puts "Total Users: #{users.length}"
  puts "Choosers: #{choosers.length}"
  puts "Chosen: #{chosen.length}"
  puts "Chosen (Unique): #{chosen.uniq.length}"
  puts "Avg \# Choices: #{choicesEdges.length.to_f / choosers.length.to_f}"
  puts "Mutual Choices: #{mutuals.length}"
  puts "Reflexive Mutual Choices: #{mutuals.length - mutuals_legit.length}"
  puts "Mutual Choices without Reflexive: #{mutuals_legit.length}"
  puts "Unique Users Matched: #{matched.length}"
  puts "-----"
  puts "Participation: #{100.0*(choosers.length.to_f / users.length.to_f)}"
  puts ""

  puts "Top Chosen"
  agg.sort_by { |k,v| v }.reverse[0..10].each do |u|
    #puts "#{u[0]} by #{u[1]} users"
  end

  return
end

puts "***** Type 'crushed' to see some stats *****"