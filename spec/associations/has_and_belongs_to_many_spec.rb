require 'acts_as_mergeable/associations/has_and_belongs_to_many'

RSpec.describe HasAndBelongsToMany do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:clubs_for_both) { create_list(:club, 2) }
  let(:main_clubs) { create_list(:club, 2) }
  let(:other_clubs) { create_list(:club, 2) }

  before do
    main_user.clubs << main_clubs
    other_user.clubs << other_clubs
    other_user.clubs << clubs_for_both
    main_user.clubs << clubs_for_both

    HasAndBelongsToMany.merge(main_user, other_user)
  end

  it 'should copy all the associated relations that is not already associated' do
    expect(main_user.clubs).to include(*other_clubs)
  end

  it 'should not duplicate already existing relations' do
    expect(main_user.clubs.count).to eq 6
  end
end
