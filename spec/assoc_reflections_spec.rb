require 'acts_as_mergeable/assoc_reflections'

RSpec.describe AssocReflections do
  let(:user) { User.new }

  it 'responds with associations to given object by the given relationship' do
    expect(AssocReflections.reflections_for(user, :has_many)).to eq([:houses, :cars, :shoes])
    expect(AssocReflections.reflections_for(user, :has_one)).to eq([:spouse, :profile])
    expect(AssocReflections.reflections_for(user, :belongs_to)).to eq([:club, :age_group])
  end

  it "doesn't include 'through' relationships" do
    house = House.create(user: user)
    expect(AssocReflections.reflections_for(house, :has_many)).to eq([:rooms])
    expect(AssocReflections.reflections_for(user, :has_many)).not_to include(:rooms)
  end
end
