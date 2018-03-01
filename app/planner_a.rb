class PlannerA
    
    def initialize(world)
        @cars = world.cars
        @rides = world.rides
    end
    
    def plan
        @cars.each do |car|
            car.rides << @rides.pop
        end
    end
end