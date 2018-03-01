require_relative '../app/file_reader.rb'

RSpec.describe FileReader do
  it 'works for a simple file' do
    world = FileReader.new('input_sets/a_example.in').world
    expect(world.cars.count).to eq 2
    expect(world.rides.count).to eq 3
    expect(world.ticks).to eq 10
    expect(world.bonus).to eq 2
  end
end