require 'acts_as_mergeable/assoc_reflections'

RSpec.describe AssocReflections do
  let(:user) { User.new }

  it 'responds with associations to given object by the given relationship' do
    expect(AssocReflections.reflections_for(user, :has_many).map(&:name)).to eq([:houses, :cars, :shoes])
    expect(AssocReflections.reflections_for(user, :has_one).map(&:name)).to eq([:spouse, :profile])
    expect(AssocReflections.reflections_for(user, :belongs_to).map(&:name)).to eq([:club, :age_group])
  end

  it "doesn't include 'through' relationships" do
    house = House.create(user: user)
    expect(AssocReflections.reflections_for(house, :has_many).map(&:name)).to eq([:rooms])
    expect(AssocReflections.reflections_for(user, :has_many).map(&:name)).not_to include(:rooms)
  end
end
