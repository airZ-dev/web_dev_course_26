require 'date'
Struct.new("Team", :name, :id, :playedTeams);

# Struct::Team.new("dfdfdf", 12, ["asdas", "asdsd"]);

def ParseTeams(path)
  lines = File.readlines(path).map{|line|
    splits = line.split('.')
    splits2 = splits[1].split('—').map{|x|x.strip}
    team = Struct::Team.new(
      splits2[1].strip,
      splits[0].to_i,
      Array.new()
      )
     };
  for x in lines
    lines.each{|l|
      if l[1] != x[1] then x[2].push(l[1]) end;}
  end;
  lines;
end;

def GenerateDateRange(beginD, endD)
  if endD - beginD <= 0
    raise "Date uncorrect"
  end;
  result = Array.new()
  needlyDays = [0,5,6]
  currentDate = beginD
  while currentDate.wday != 0
    if needlyDays.include?(currentDate.wday)
      result.push(currentDate)
    end;
    currentDate+=1
  end;
  while currentDate <= endD
    result.push(currentDate).push(currentDate+5).push(currentDate+6)
    currentDate+=7
  end;
result
end;

if ARGV.length != 4
  raise "loss parameters"
end

lines = ParseTeams(ARGV[0]);
startDate = Date.strptime(ARGV[1], "%d.%m.%Y")
endDate = Date.strptime(ARGV[2], "%d.%m.%Y")
resultTime = GenerateDateRange(startDate, endDate)
puts resultTime


#puts finalTeams;
#lines.each { |line| puts line };
