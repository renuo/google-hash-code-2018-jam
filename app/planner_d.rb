class PlannerD
    attr_accessor :world
    def initialize(world)
        self.world = world
    end
    
    def cars
        world.cars
    end
    
    def rides
        world.rides
    end
    
    def plan
        sort_rides
        i = 0
        while true
            break if cars.all?(&:done)
            car = cars[i]
            next if car.done
            # puts "assigning to car #{i} in position #{car.position}"
            rides_before = car.rides.count
            find_next_ride(car)
            rides_now = car.rides.count
            if rides_before == rides_now
                car.done = true
            end
            i = (i + 1) % cars.count
        end
    end
    
    def free?(car)
        car.tick < world.ticks
    end
    
    def find_next_ride(car)
        rides.each do |ride|
            next if ride.taken?
            next if ride.earliest_start < car.tick + world.distance_to_point(car.position, ride.start_point)
            assign(car, ride)
        end
    end
    
    def assign(car, ride)
        car.rides << ride
        ride.car = car
        car.tick += world.tick_cost_for_ride(car, ride)
        car.position = ride.finish_point
    end
    
    def sort_rides
       rides.sort_by! {|ride| ride.earliest_start}
    end
end