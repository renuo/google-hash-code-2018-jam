class PlannerD
    attr_accessor :world, :rides
    def initialize(world)
        self.world = world
        self.rides = world.rides
    end
    
    def cars
        world.cars
    end
    
    def plan_j(rides)
        self.rides = rides
        plan
    end
    
    def plan
        sort_rides
        
        cars.each do |car|
            while !car.done
                rides_before = car.rides.count
                find_next_ride2(car)
                rides_now = car.rides.count
                if rides_before == rides_now
                    car.done = true
                end
            end
        end
    end
    
    # def plan
    #     sort_rides
    #     i = 0
        
        
    #     while true
    #         break if cars.all?(&:done)
    #         car = cars[i]
    #         next if car.done
    #         # puts "assigning to car #{i} in position #{car.position}"
    #         rides_before = car.rides.count
    #         find_next_ride(car)
    #         rides_now = car.rides.count
    #         if rides_before == rides_now
    #             car.done = true
    #         end
    #         i = (i + 1) % cars.count
    #     end
    # end
    
    def free?(car)
        car.tick < world.ticks
    end
    
    def set_chosen_ride(chosen_ride, car, ride, bonus, cost)
        chosen_ride[:ride] = ride
        chosen_ride[:cost] = cost
        chosen_ride[:bonus] = bonus
    end
    
    def find_next_ride(car)
        chosen_ride = {ride: nil, cost: 9999999, bonus: false}
        rides.each do |ride|
            next if ride.taken?
            next unless world.can_car_make_the_ride?(car, ride)
            bonus = world.can_car_get_the_bonus?(car, ride)
            cost = world.tick_cost_for_ride(car, ride) - ride.distance - rand(1..10)
            if chosen_ride[:ride].nil?
                set_chosen_ride(chosen_ride, car, ride, bonus, cost)
            else
                if bonus
                    if chosen_ride[:bonus]
                        if cost < chosen_ride[:cost]
                            set_chosen_ride(chosen_ride, car, ride, bonus, cost)
                        end
                    else
                        set_chosen_ride(chosen_ride, car, ride, bonus, cost)
                    end
                else
                    if chosen_ride[:bonus]
                        # noop
                    else
                        if cost < chosen_ride[:cost]
                            set_chosen_ride(chosen_ride, car, ride, bonus, cost)
                        end
                    end 
                end
            end
        end
        # puts "chosen: #{chosen_ride[:ride]}"
        world.assign(car, chosen_ride[:ride]) if chosen_ride[:ride]
    end
    
    def find_next_ride2(car)
        chosen_ride = {ride: nil, cost: 9999999}
        rides.each do |ride|
            next if ride.taken?
            next unless world.can_car_make_the_ride?(car, ride)
            bonus = world.can_car_get_the_bonus?(car, ride)
            cost = world.tick_cost_for_ride(car, ride) - ride.distance
            real_cost = ((bonus ? world.bonus : 0) + ride.distance) / (cost + 0.001)
            if real_cost < chosen_ride[:cost]
                set_chosen_ride(chosen_ride, car, ride, bonus, real_cost)
            end
        end
        world.assign(car, chosen_ride[:ride]) if chosen_ride[:ride]
    end
    
    def sort_rides
       rides.sort_by! {|ride| [ride.earliest_start, -ride.distance] }
    end
end