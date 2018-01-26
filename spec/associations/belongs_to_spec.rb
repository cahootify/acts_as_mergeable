require 'acts_as_mergeable/associations/belongs_to'

RSpec.describe BelongsTo do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:main_age_group) { create(:age_group) }
  let(:other_age_group) { create(:age_group) }

  context 'when main object has a relation' do
    before do
      main_user.update(age_group: main_age_group)
      other_user.update(age_group: other_age_group)
    end

    it 'should retain main objects relation' do
      expect{ BelongsTo.merge(main_user, other_user) }.not_to change(main_user, :age_group_id)
    end
  end

  context 'when main object has no relation' do
    before do
      main_user.update(age_group: nil)
      other_user.update(age_group: other_age_group)
    end

    it 'should copy relation from merging instance to the main objects' do
      expect{ BelongsTo.merge(main_user, other_user) }.to change(main_user, :age_group_id).to other_age_group.id
    end
  end
end
