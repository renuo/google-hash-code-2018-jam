class PlannerB
    
    def initialize(world)
        @world = world
        @cars = world.cars
        @rides = world.rides
    end
    
    def plan(rides)
       rides.sort_by! {|ride| ride.earliest_start}
       while rides.any? do
         next_ride = rides.first
        # puts 'selecting next ride'
         car_with_lowest_path_cost = {cost: 100000, car: nil}
         @cars.each do |car|
           cost = tick_cost_for_ride(car, next_ride)
            if @world.can_car_make_the_ride?(car, next_ride) && (car_with_lowest_path_cost[:cost] > cost)
            #   puts 'got a new car which can take it!'
              car_with_lowest_path_cost[:cost] = cost
              car_with_lowest_path_cost[:car] = car
            end
          end
          car_which_does_the_ride = car_with_lowest_path_cost[:car]
          if car_which_does_the_ride != nil
            # car_which_does_the_ride.rides << next_ride
            # car_which_does_the_ride.tick = car_which_does_the_ride.tick + car_with_lowest_path_cost[:cost]
            # car_which_does_the_ride.position = next_ride.finish_point
            @world.assign(car_which_does_the_ride, next_ride)
          end
          rides.shift
       end
    end
    
    def plan_c
       @rides.sort_by! {|ride| ride.earliest_start}
       while @rides.any? do
         next_ride = @rides.first
         car_with_lowest_path_cost = {cost: 100000, car: nil}
         @cars.each do |car|
          wait_time = @world.wait_time(car, next_ride)
           bonus = @world.can_car_get_the_bonus?(car, next_ride)
           cost = tick_cost_for_ride(car, next_ride) - next_ride.distance + rand(1..100)
            if @world.can_car_make_the_ride?(car, next_ride) && (car_with_lowest_path_cost[:cost] > cost)
              car_with_lowest_path_cost[:cost] = cost
              car_with_lowest_path_cost[:car] = car
            end
          end
          car_which_does_the_ride = car_with_lowest_path_cost[:car]
          if car_which_does_the_ride != nil
            @world.assign(car_which_does_the_ride, next_ride)
          end
          @rides.shift
       end
    end
    
     def plan_d
       @rides.sort_by! {|ride| ride.earliest_start}
       while @rides.any? do
         next_ride = @rides.first
        # puts 'selecting next ride'
         car_with_lowest_path_cost = {cost: 100000, car: nil, bonus: false}
         @cars.each do |car|
           wait_time = @world.wait_time(car, next_ride)
           cost = tick_cost_for_ride(car, next_ride) - next_ride.distance
            if @world.can_car_make_the_ride?(car, next_ride)
                bonus = @world.can_car_get_the_bonus?(car, next_ride)
                if (bonus)
                   if (car_with_lowest_path_cost[:bonus])
                        if (car_with_lowest_path_cost[:cost] > cost)
                            car_with_lowest_path_cost[:cost] = cost
                            car_with_lowest_path_cost[:car] = car
                        end 
                   else
                       car_with_lowest_path_cost[:cost] = cost
                       car_with_lowest_path_cost[:car] = car
                       car_with_lowest_path_cost[:bonus] = true
                   end
                else
                    if (!car_with_lowest_path_cost[:bonus] && car_with_lowest_path_cost[:cost] > cost)
                        car_with_lowest_path_cost[:cost] = cost
                        car_with_lowest_path_cost[:car] = car
                    end
                end
            end
          end
          car_which_does_the_ride = car_with_lowest_path_cost[:car]
          if car_which_does_the_ride != nil
            @world.assign(car_which_does_the_ride, next_ride)
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