require_relative '../app/world.rb'
require_relative '../app/planner_a.rb'

RSpec.describe World do
    it 'creates a fake world' do
        world = World.fake
        expect(world.cars.count).to eq 2
        expect(world.rides.count).to eq 3
    end
    
    it 'plans' do
        world = World.fake
        planner = PlannerA.new(world)
        planner.plan
    end
end
