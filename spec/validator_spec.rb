require_relative '../app/validator.rb'
require_relative '../app/file_writer.rb'

RSpec.describe Validator do
  it 'works for a simple file' do
   input_file_path = 'input_sets/simple.in'
    world = FileReader.new(input_file_path).world
    world.unleash_the_cars
    file_path = 'output_sets/simple.out'
    FileWriter.new(world, file_path)
    Validator.new(input_file_path, file_path)
  end
end