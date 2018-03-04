require_relative './world.rb'

class FileReader
    def initialize(file_path)
        @file = File.read(file_path)
    end
    
    def world
        lines = @file.split(/\n/)
        first_line = lines[0].split
        rows = first_line[0].to_i
        columns = first_line[1].to_i
        cars_count = first_line[2].to_i
        rides_count = first_line[3].to_i
        bonus = first_line[4].to_i
        ticks = first_line[5].to_i
        rides = rides_count.times.map do |i|
            line = lines[i+1].split(' ')
            start_point = [line[0].to_i, line[1].to_i]
            finish_point = [line[2].to_i, line[3].to_i]
            earliest_start = line[4].to_i
            latest_finish = line[5].to_i
            Ride.new(start_point: start_point, 
            finish_point: finish_point, 
            earliest_start: earliest_start, 
            latest_finish: latest_finish, 
            id: i)
        end
        World.new(rows: rows, columns: columns, cars_count: cars_count, rides: rides, bonus: bonus, ticks: ticks)
    end
end