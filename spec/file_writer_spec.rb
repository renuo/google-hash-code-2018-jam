require_relative '../app/file_reader.rb'
require_relative '../app/file_writer.rb'

RSpec.describe FileWriter do
   it 'works for a simple file' do
      world = FileReader.new('input_sets/a_example.in').world
      FileWriter.new(world, 'output_sets/a_example.out')
   end
end