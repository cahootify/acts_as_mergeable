require 'acts_as_mergeable/associations/has_one'

RSpec.describe HasOne do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:main_profile) { create(:profile) }
  let(:other_profile) { create(:profile) }

  context 'when main object has a relation' do
    let(:county) { create(:county) }
    let(:clubs) { create_list(:club, 2) }
    let!(:book) { create(:book, profile: other_profile) }
    let!(:emails) { create_list(:email, 2, profile: other_profile) }

    before do
      main_profile.update(user: main_user)
      other_profile.update(user: other_user)
      other_profile.update(county: county)
      other_profile.clubs << clubs

      HasOne.merge(main_user, other_user)
    end

    it 'should retain main objects relation' do
      expect(main_user.reload.profile).to eq main_profile
    end

    it 'should move other associations from relation of instance getting merged to relation of main' do
      expect(main_profile.reload.county).to eq county
      expect(main_profile.reload.book).to eq book
      expect(main_profile.reload.emails).to include(*emails)
      expect(main_profile.reload.clubs).to include(*clubs)
    end
  end

  context 'when main object has no relation' do
    before do
      main_profile.update(user: nil)
      other_profile.update(user: other_user)
    end

    it 'should copy relation from merging instance to the main objects' do
      HasOne.merge(main_user, other_user)
      expect(main_user.reload.profile).to eq other_profile
    end
  end
end
