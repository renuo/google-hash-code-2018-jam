require 'ostruct'

class ClosedStruct
    def initialize(args)
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
    end
end
    
class Ride < ClosedStruct
    attr_accessor :start_point, :finish_point, :earliest_start, :latest_finish, :id, :car
    
    def initialize(args)
        super(args)
    end
    
    def distance
      (start_point[0] - finish_point[0]).abs + (start_point[1] - finish_point[1]).abs
    end
    
    def taken?
        !car.nil?
    end
end

class Car < ClosedStruct
    attr_accessor :position, :rides, :tick, :done
    
    def initialize(args = {})
        super(args)
        self.position = [0,0]
        self.tick = 0
        self.rides = []
        self.done = false
    end
end

class World < ClosedStruct
    attr_accessor :rows, :columns, :cars, :rides, :bonus, :ticks
    def initialize(args)
        super(args)
        self.cars = args[:cars_count].times.map { Car.new }
    end
    
    def self.fake
        rides = [Ride.new(start_point: [0,0], finish_point: [1,3], earliest_start: 2, latest_finish: 9, id: 0),
        Ride.new(start_point: [1,2], finish_point: [1,0], earliest_start: 0, latest_finish: 9, id: 1),
        Ride.new(start_point: [2,0], finish_point: [2,2], earliest_start: 0, latest_finish: 9, id: 2)]
        new(rows: 3, columns: 4, cars_count: 2, rides: rides, bonus: 2, ticks: 10)
    end
    
    def tick_cost_for_ride(car, ride)
      t0 = car.tick
      t1 = distance_to_point(car.position, ride.start_point)
      t2 = (t1 + t0)
      t3 = ride.distance
      t1 + t3 + [0, ride.earliest_start - t2].max
    end
    
    def distance_to_point(point_a, point_b)
      (point_a[0] - point_b[0]).abs + (point_a[1] - point_b[1]).abs
    end
end
