require_relative '../app/file_reader.rb'
require_relative '../app/file_writer.rb'

RSpec.describe 'everything works' do
  it 'works for a simple file' do
    file_names = ['a_example', 'b_should_be_easy', 'c_no_hurry', 'd_metropolis', 'e_high_bonus']
    file_names.each do |file_name|
      world = FileReader.new("input_sets/#{file_name}.in").world
      planner = PlannerA.new(world)
      planner.plan
      FileWriter.new(world, "output_sets/#{file_name}.out")
    end
  end
end