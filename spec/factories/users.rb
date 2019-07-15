FactoryBot.define do
  factory :first_user do
    name                  { "First Example" }
    email                 { "michael@example.com" }
    password              { "password" }
    password_confirmation { "password" }
    admin                 { true }
  end

  factory :second_user do
    name                  { "Second Example" }
    email                 { "bbb@co.jp" }
    password              { "password" }
    password_confirmation { "password" }
  end

  factory :archer do
    name                  { "Sterling Archer" }
    email                 { "bbb@co.jp" }
    password              { "password" }
    password_confirmation { "password" }
  end
 
  factory :lana do
    name                  { "Lana Kane" }
    email                 { "hands@example.gov" }
    password              { "password" }
    password_confirmation { "password" }
  end

  factory :malory do
    name                  { "Malory Archer" }
    email                 { "boss@example.gov" }
    password              { "password" }
    password_confirmation { "password" }
  end
end
