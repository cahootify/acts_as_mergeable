require 'acts_as_mergeable/associations/belongs_to'

RSpec.describe BelongsTo do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:main_club) { create(:club) }
  let(:other_club) { create(:club) }

  context 'when main object has a relation' do
    before do
      main_user.update(club: main_club)
      other_user.update(club: other_club)
    end

    it 'should retain main objects relation' do
      expect{ BelongsTo.merge(main_user, other_user) }.not_to change(main_user, :club_id)
    end
  end

  context 'when main object has no relation' do
    before do
      main_user.update(club: nil)
      other_user.update(club: other_club)
    end

    it 'should copy relation from merging instance to the main objects' do
      expect{ BelongsTo.merge(main_user, other_user) }.to change(main_user, :club_id).to other_club.id
    end
  end
end
