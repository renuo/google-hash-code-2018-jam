require_relative '../app/world.rb'

RSpec.describe World do
    it 'can build a node' do
        node = Node.new(latitude: 48.858, longitude: 22.2945)
        expect(node.latitude).to eq 48.858
    end
    
    it 'creates a fake world' do
        world = World.fake
        expect(world.nodes.count).to eq 3
        expect(world.streets.count).to eq 3
    end
end
