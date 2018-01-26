require 'acts_as_mergeable/associations/has_many'
require 'acts_as_mergeable/associations/has_one'
require 'acts_as_mergeable/associations/has_and_belongs_to_many'
require 'acts_as_mergeable/associations/belongs_to'

RSpec.describe ActsAsMergeable do
  let(:main_user) { create(:user) }
  let(:other_user) { create(:user) }

  it "has a version number" do
    expect(ActsAsMergeable::VERSION).not_to be nil
  end

  it "calls merge on all of known associations" do
    expect(HasMany).to receive(:merge).with(main_user, other_user)
    expect(HasOne).to receive(:merge).with(main_user, other_user)
    expect(HasAndBelongsToMany).to receive(:merge).with(main_user, other_user)
    expect(BelongsTo).to receive(:merge).with(main_user, other_user)

    main_user.merge(other_user)
  end

  it 'should not allow calling "merge" on objs of diff classes' do
    book = build(:book)

    expect{ main_user.merge(book) }.to raise_error('YEET!!!')
  end

  it 'should copy attributes from child instance if not already present' do
    main_user.name = 'Main Name'
    main_user.age = 57
    main_user.dob = nil

    other_user.name = 'Other Name'
    other_user.age = nil
    other_user.dob = '1997-01-26'

    main_user.merge(other_user)

    # name shouldn't change since it was already present
    expect(main_user.name).to eq 'Main Name'
    # age shouldn't change either
    expect(main_user.age).to eq 57
    # dob should have been copied from other user, as main_user previously has no dob.
    expect(main_user.reload.dob).to eq '1997-01-26'
  end
end
