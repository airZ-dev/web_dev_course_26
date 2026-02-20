require 'date'
require 'json'
#описание структуры команд
Struct.new("Team", :name, :id, :playedTeams);

#функция парсинга входного файла команд
def ParseTeams(path)
  lines = File.readlines(path).map{|line|
    splits = line.split('.')
    splits2 = splits[1].split('—').map{|x|x.strip}
    team = Struct::Team.new(
      splits2[0].strip,
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

#функция фильтрации дат по пятницам субботам и воскресеньям
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
      result.push(currentDate)
      if(currentDate <= endD-5) then result.push(currentDate+5) end
      if(currentDate <= endD-6) then result.push(currentDate+6) end
    currentDate+=7
  end;
result
end;

#функция для равномерного распределения по доступным дням по 2 матча
def DistributionBy2(lines, dates)
    resultData = Array.new()
    step = (dates.length*2*1.0/(((1..(lines.length-1)).sum()))).ceil
    0.step(dates.length, step) do |j|
        for i in 1..2 do
            randS = rand(1..lines.length)
            firstTeam = lines.find{|line| line[1] == randS}
            if(firstTeam==nil)
                while(firstTeam==nil)
                    randS = rand(1..lines.length)
                    firstTeam = lines.find{|line| line[1] == randS}
                end
            end
            randS2 = rand(1..lines.length)
            secondTeam = lines.find{|line| line[1] == randS2 and firstTeam[2].include?(randS2)}
            if(secondTeam==nil)
               while(secondTeam==nil)
                   randS2 = rand(1..lines.length)
                   secondTeam = lines.find{|line| line[1] == randS2 and firstTeam[2].include?(randS2)} #error maybe
               end
            end
            if i == 1
               resultData.push('{"FirstTeam": ' + '"' +firstTeam[0] + '"' + ', "SecondTeam": ' + '"' + secondTeam[0] + '"' + ', "Date": ' + '"' + String(dates[j]) + '"' + ', "Time": "12:00"}')
            elsif i == 2
              resultData.push('{"FirstTeam": ' + '"' +firstTeam[0] + '"' + ', "SecondTeam": ' + '"' + secondTeam[0] + '"' + ', "Date": ' + '"' + String(dates[j]) + '"' + ', "Time": "18:00"}')
            end
            lines.find{|line|line[1] == randS}[2].delete(randS2)
            lines.find{|line|line[1] == randS2}[2].delete(randS)
        end
    end
        return resultData.map{|x|JSON.parse(x)}
end

#функция записи календаря в файл json формата
def WriteOutputFile(filePath, jsonData)
    if(!filePath.include?(".txt"))
        raise "Output file isnt correct"
    end
    File.open(filePath, 'w') do |file|
        file.write(file)
    end
    puts "data write successfully"
end


#проверка количества входных аргументов
if ARGV.length != 4
      raise "loss parameters"
    end

#блок вызова кода
lines = ParseTeams(ARGV[0]);
startDate = Date.strptime(ARGV[1], "%d.%m.%Y")
endDate = Date.strptime(ARGV[2], "%d.%m.%Y")
resultTime = GenerateDateRange(startDate, endDate)
correctData = DistributionBy2(lines, resultTime)
WriteOutputFile(ARGV[3], correctData)
