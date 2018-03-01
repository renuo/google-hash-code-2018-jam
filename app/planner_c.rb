class PlannerC
    
    def initialize(world)
        @cars = world.cars
        @rides = world.rides
    end
    
    def plan
        fields = @world.rows * @world.columns
        sector_size = Math.sqrt(fields)
        square_side = Math.sqrt(sector_size)
        
        sector_rows = @world.rows / square_side
        sector_columns = @world.columns / square_side
        
        [*0..sector_rows].each do |row|
            [*0..sector_columns].each do |column|
                
            end
        end
    end
    
    def sort_rides
       @rides.sort_by! {|ride| ride.earliest_start}
    end
    
    def nearest_ride(time, position)
        
    end
    
    def distance_to_point(point_a, point_b)
      (point_a[0] - point_b[0]).abs + (point_a[1] - point_b[1]).abs
    end
end