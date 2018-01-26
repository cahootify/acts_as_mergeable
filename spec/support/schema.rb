ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.integer :age
    t.integer :spouse_id
    t.integer :profile_id
    t.integer :age_group_id
    t.datetime :dob

    t.timestamps
  end

  create_table :age_groups, force: true do |t|
    t.string :name
  end

  create_table :cars, force: true do |t|
    t.string :name
    t.integer :user_id
  end

  create_table :clubs, force: true do |t|
    t.string :name
  end

  create_table :clubs_users, force: true do |t|
    t.integer :user_id
    t.integer :club_id
  end

  create_table :houses, force: true do |t|
    t.string :address
    t.integer :user_id
  end

  create_table :profiles, force: true do |t|
    t.string :email
    t.integer :user_id
    t.integer :county_id
  end

  create_table :rooms, force: true do |t|
    t.string :size
    t.integer :house_id
  end

  create_table :shoes, force: true do |t|
    t.string :brand
    t.integer :user_id
  end

  create_table :emails, force: true do |t|
    t.integer :profile_id
    t.string :email
  end

  create_table :books, force: true do |t|
    t.string :title
    t.integer :profile_id
  end

  create_table :clubs_profiles, force: true do |t|
    t.integer :club_id
    t.integer :profile_id
  end

  create_table :counties, force: true do |t|
    t.string :name
  end
end
