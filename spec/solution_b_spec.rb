require_relative '../app/file_reader.rb'
require_relative '../app/file_writer.rb'
require_relative '../app/planner_b.rb'

RSpec.describe 'everything works' do
  it 'works for a simple file' do
    file_names = ['a_example', 'b_should_be_easy', 'c_no_hurry', 'd_metropolis', 'e_high_bonus']
    file_names.each do |file_name|
      world = FileReader.new("input_sets/#{file_name}.in").world
      planner = PlannerB.new(world)
      planner.plan_c
      FileWriter.new(world, "output_sets/matthias/#{file_name}.out")
    end
  end
end