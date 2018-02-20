require_relative '../app/file_reader.rb'
require_relative '../app/file_writer.rb'

RSpec.describe FileWriter do
  it 'works for a simple file' do
    world = FileReader.new('input_sets/simple.in').world
    world.unleash_the_cars
    file_path = 'output_sets/simple.out'
    FileWriter.new(world, file_path)
    file = File.read(file_path)
    lines = file.split(/\n/)
    expect(lines.count).to eq 139
  end
  
  it 'works for a Paris file' do
    world = FileReader.new('input_sets/paris.in').world
    world.unleash_the_cars
    file_path = 'output_sets/paris.out'
    FileWriter.new(world, file_path)
    file = File.read(file_path)
    lines = file.split(/\n/)
  end
end