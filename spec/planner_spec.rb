require_relative '../app/world.rb'

RSpec.describe Planner do
  let(:world) { World.fake }
  let(:instance) { described_class.new(world, world.cars.first) }
  
  describe '#planned_nodes' do
    subject { instance.planned_nodes }
    it { is_expected.to be_an(Enumerable) }
  end
  
  describe '#plan' do
    it 'plans in some nodes to visit' do
      expect{ instance.plan }.to change{ instance.planned_nodes }
    end
  end
end
