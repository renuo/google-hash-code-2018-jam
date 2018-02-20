require_relative './world.rb'

class FileReader
    def initialize(file_path)
        @file = File.read(file_path)
    end
    
    def world
        lines = @file.split(/\n/)
        first_line = lines[0].split
        nodes_count = first_line[0].to_i
        streets_count = first_line[1].to_i
        time_budget = first_line[2].to_i
        cars_count = first_line[3].to_i
        starting_node  = first_line[4].to_i
        nodes = nodes_count.times.map do |i|
            node_line = lines[i + 1].split
            Node.new(latitude: node_line[0], longitude: node_line[1], index: i)
        end
        streets = []
        streets_count.times do |j|
            street_line = lines[nodes_count + j + 1].split
            node_a = nodes[street_line[0].to_i]
            node_b = nodes[street_line[1].to_i]
            direction = street_line[2].to_i
            time = street_line[3].to_i
            distance = street_line[4].to_i
            street_a = Street.new(node_a: node_a, node_b: node_b, time_cost: time, length: distance)
            if direction == 2
                street_b = Street.new(node_a: node_b, node_b: node_a, time_cost: time, length: distance, opposite_street: street_a)
                street_a.opposite_street = street_b
                streets << street_b
            end
            streets << street_a
        end
        
        cars = cars_count.times.map do |i|
            Car.new(time_budget, starting_node)
        end
        
        World.new(nodes: nodes, streets: streets, cars: cars)
    end
end