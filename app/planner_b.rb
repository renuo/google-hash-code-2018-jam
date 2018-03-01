class PlannerB
    
    def initialize(world)
        @cars = world.cars
        @rides = world.rides
    end
    
    def plan
       @rides.sort_by! {|ride| ride.earliest_start}
       while @rides.any? do
         next_ride = @rides.first
         puts 'selecting next ride'
         car_with_lowest_path_cost = {cost: 0, car: nil}
         @cars.each do |car|
           cost = tick_cost_for_ride(car, next_ride)
           puts "cost for car #{car.position} is #{cost}"
            if (cost < next_ride.latest_finish - car.tick) && (car_with_lowest_path_cost[:cost] > cost)
              car_with_lowest_path_cost[:cost] = cost
              car_with_lowest_path_cost[:car] = car
            end
          end
          car_which_does_the_ride = car_with_lowest_path_cost[:car]
          if car_which_does_the_ride != nil
            car_which_does_the_ride.rides << next_ride
            car_which_does_the_ride.tick = car_which_does_the_ride.tick + car_with_lowest_path_cost[:cost]
            car_which_does_the_ride.position = next_ride.finish_point
          end
          @rides.shift
       end
    end
    
    def can_finish_ride_in_time(car, ride)
      tick_cost_for_ride(car, ride) < ride.latest_finish - car.tick
    end
    
    def tick_cost_for_ride(car, ride)
      t0 = car.tick
      t1 = distance_to_point(car.position, ride.start_point)
      t2 = (t1 + t0)
      t3 = distance_to_point(ride.start_point, ride.finish_point)
      t1 + t3 + [0, ride.earliest_start - t2].max
    end
    
    def distance_to_point(point_a, point_b)
      d = (point_a[0] - point_b[0]).abs
      d = d + (point_a[1] - point_b[1]).abs
      d
    end
end