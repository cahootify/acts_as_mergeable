require 'acts_as_mergeable/associations/has_many'

RSpec.describe HasMany do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'no constraints' do
    before do
      other_user.houses << create_list(:house, 2)
      other_user.cars << create_list(:car, 2)

      HasMany.merge(main_user, other_user)
    end

    it 'should copy all the "has_many" associations to main object' do
      expect(main_user.houses.count).to eq 2
      expect(main_user.cars.count).to eq 2
    end

    it 'should remove the "has_many" associations from merged object' do
      expect(other_user.houses.count).to eq 0
      expect(other_user.cars.count).to eq 0
    end
  end

  describe 'when association has a max length constraint' do
    before do
      main_user.shoes << create_list(:shoe, 2)
      other_user.shoes << create_list(:shoe, 4)

      HasMany.merge(main_user, other_user)
    end

    it 'should respect the constraint' do
      expect(main_user.shoes.count).to eq 3
    end

    it 'should remove the "has_many" associations from merged object up to max-length limit' do
      # will remain 3 here, as one has been moved over to main, to fill up to max-length validation limit.
      expect(other_user.shoes.count).to eq 3
    end
  end
end
