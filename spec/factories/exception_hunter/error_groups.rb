FactoryBot.define do
  factory :error_group, class: 'ExceptionHunter::ErrorGroup' do
    error_class_name { 'ExceptionName' }
    message { 'Exception message' }
    status { :active }

    trait :ignored_group do
      status { :ignored }
    end
  end
end
