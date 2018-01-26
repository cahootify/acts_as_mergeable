FactoryBot.define do
  factory :user do
    name  "John"
    age   34
    age_group
  end

  factory :spouse, class: User, parent: :user do;end

  factory :age_group do
    name "Mid-30s"
  end

  factory :car do
    name "Ferrari"
    user
  end

  factory :club do
    name "My brother's place"
  end

  factory :house do
    address "423 Greenholt Ports"
    user
  end

  factory :profile do
    email "grant@murazik.co"
    user
  end

  factory :room do
    size "Twin"
    house
  end

  factory :shoe do
    brand "Volley"
    user
  end
end
