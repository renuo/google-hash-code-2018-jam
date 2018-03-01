class FileWriter
   def initialize(world, output_path)
      File.open(output_path, 'w') do |file|
         world.cars.each do |car|
            rides = car.rides.map(&:id).join(' ')
            file.puts "#{car.rides.count} #{rides}"
         end
         # world.cars.each do |car|
         #    file.puts car.nodes.count
         #    car.nodes.each do |node|
         #       file.puts node
         #    end
         # end
      end
   end
end