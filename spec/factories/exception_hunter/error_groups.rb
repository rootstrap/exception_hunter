FactoryBot.define do
  factory :error_group, class: 'ExceptionHunter::ErrorGroup' do
    error_class_name { 'ExceptionName' }
    message { 'Exception message' }
  end
end
