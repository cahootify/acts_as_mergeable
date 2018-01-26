require 'acts_as_mergeable/associations/has_one'

RSpec.describe HasOne do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:main_profile) { create(:profile) }
  let(:other_profile) { create(:profile) }

  context 'when main object has a relation' do
    before do
      main_profile.update(user: main_user)
      other_profile.update(user: other_user)
    end

    it 'should retain main objects relation' do
      HasOne.merge(main_user, other_user)
      expect(main_user.reload.profile).to eq main_profile
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