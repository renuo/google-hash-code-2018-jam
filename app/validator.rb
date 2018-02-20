require_relative './file_reader.rb'

class Validator
    def initialize(in_file_path, out_file_path)
        world = FileReader.new(in_file_path).world
        @input_file = File.read(in_file_path)
        @output_file = File.read(out_file_path)
        lines = @output_file.split(/\n/)
        cars_number = lines[0].to_i
        raise Exeption.new('wrong number of cars') if cars_number != world.cars.count
        puts "You moved #{cars_number} cars"
        offset = 1
        cars_number.times do |car_index|
            car_nodes = lines[offset].to_i
            puts "Car #{car_index} moved into #{car_nodes} nodes"
            offset += (1 + car_nodes)
        end
    end
end