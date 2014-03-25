# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |n|
    email 'factory@girl.com'
    password 'changeme'
    password_confirmation 'changeme'
  end
end

# cool code to implement later

# FactoryGirl.define do
#   sequence :name do |n|
#     "User_#{n}"
#   end

#   sequence :email do |n|
#     "User_#{n}@mail.com"
#   end

#   factory :user do
#     name
#     email
#     password "password"
#   end
# end
