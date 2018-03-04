require_relative './planner_b.rb'

class PlannerC
    class Sector
        attr_accessor :rows, :columns, :cars, :rides
        
       def initialize(min_row, min_column, square_side)
           @rows = min_row..(min_row + square_side)
           @columns = min_column..(min_column + square_side)
           @cars = []
           @rides = []
       end
       
       def contains?(row, column)
           @rows.include?(row) && @columns.include?(column)
       end
       
       def to_s
           "cars: #{@cars.count}, rides: #{@rides.count}"
       end
    end
    
    def initialize(world)
        @world = world
        @cars = world.cars
        @rides = world.rides
    end
    
    def plan
        intersection_count = @world.rows * @world.columns
        sector_size = intersection_count / @cars.count
        square_side = Math.sqrt(sector_size).to_i
        
        puts "Rows: #{@world.rows}"
        puts "Columns: #{@world.columns}"
        puts "Cars: #{@cars.count}"
        puts "Rides: #{@rides.count}"
        puts "Intersections: #{intersection_count}"
        puts "Max cells per sector: #{sector_size}"
        puts "Square side length: #{square_side}"
        
        # Create sectors
        sector_rows = (@world.rows / square_side).to_i
        sector_columns = (@world.columns / square_side).to_i
        puts "Sector rows #{sector_rows}"
        puts "Sector columns #{sector_columns}"
        
        sectors = []
        [*0..sector_rows].each do |row|
            [*0..sector_columns].each do |column|
                row_offset = row * square_side
                column_offset = column * square_side
                sectors << Sector.new(row_offset, column_offset, square_side)
            end
        end

        # Partition rides to sectors
        @rides.each do |ride|
            sector = sectors.find do |s|
                ride if s.contains?(ride.start_point[0], ride.start_point[1])
            end
            
            sector.rides << ride if sector
        end
                
        # Assign a sector to each car
        @cars.each_with_index do |car, index|
            sectors[index].cars << car
        end
        
        
        # Do the rides for each sector
        sectors.each do |sector|
            planner_b = PlannerB.new(@world)
            planner_b.plan(sector.rides)
        end
    end
end