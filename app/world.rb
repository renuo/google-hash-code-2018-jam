require 'ostruct'

class ClosedStruct
    def initialize(args)
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
    end
end
    
class Node < ClosedStruct
    attr_accessor :latitude, :longitude, :streets_leaving, :index
    
    def initialize(args)
        super(args)
        self.streets_leaving ||= []
    end
end

class Street < ClosedStruct
    attr_accessor :node_a, :node_b, :time_cost, :length, :visited, :opposite_street
end

class Car
    attr_accessor :time_budget, :nodes, :streets
    
    def initialize(time_budget, initial_node)
        self.time_budget = time_budget
        self.nodes = []
        self.streets = []
        nodes << initial_node
    end
    
    def location
         nodes.last
    end
end

class World < ClosedStruct
    attr_accessor :nodes, :streets, :cars
    
    def initialize(args)
        super(args)
        streets.each do |street|
            street.node_a.streets_leaving << street
        end
    end
    
    def self.fake
        nodes = [Node.new(latitude: 48.8582, longitude: 2.2945),
                Node.new(latitude: 50.0, longitude: 3.09),
                Node.new(latitude: 51.424242, longitude: 3.02)]
        streets = [Street.new(node_a: nodes[0], node_b: nodes[1], time_cost: 30, length: 250),
                    Street.new(node_a: nodes[1], node_b: nodes[2], time_cost: 45, length: 200),
                    Street.new(node_a: nodes[2], node_b: nodes[1], time_cost: 45, length: 200)]
        cars = [Car.new(3000, 0), Car.new(3000, 0)]
        new(nodes: nodes, streets: streets, cars: cars)
    end
    
    def unleash_the_cars
        @visited_streets = []
        
        cars.each do |car|
          planner = Planner.new(self, car)
          planner.plan
          car.nodes += planner.planned_nodes.map(&:index)
          
          planner.planned_streets.each do |street|
              @visited_streets << street unless @visited_streets.include?(street.opposite_street)
          end
        end
        
        @visited_streets = @visited_streets.select
        puts "Score: #{@visited_streets.uniq.sum(&:length)}"
    end
end

class Planner
    attr_reader :planned_nodes, :planned_streets
    
    def initialize(world, car)
        @world = world
        @car = car
        @budget = car.time_budget
        @planned_nodes = []
        @planned_streets = []
    end
    
    def plan
        current_node = @world.nodes[@car.location]
        while @budget > 0 do
            street = choose_street(current_node)
            @budget -= street.time_cost
            break if @budget < 0
            current_node = street.node_b
            street.visited = true
            self.planned_streets << street
            self.planned_nodes << current_node
        end
    end
    
    def choose_street(current_node)
        candidates = current_node.streets_leaving.select { |street| street.visited != true }
        if candidates.count > 0
            candidates.sample
        else
            current_node.streets_leaving.sample
        end
    end
end
