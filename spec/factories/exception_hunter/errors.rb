FactoryBot.define do
  factory :error, class: 'ExceptionHunter::Error' do
    class_name { 'ExceptionName' }
    message { 'Exception message' }
    ocurred_at { '2020-03-25 10:27:33' }
    environment_data do
      {
        target: 'http://socialWebExample.com/users',
        referer: 'http://socialWebExample.com/',
        params: { controller: 'users', action: 'index' },
        user_agent: 'Mozilla 5.0 (X11; Linux x86_64) AppleWebKit 534.30 (KHTML, like Gecko)',
        user_info: 'sid345'
      }
    end
    custom_data do
      {
        followers_ids: [4, 67, 98],
        follow_ids: [4, 67, 104, 502]
      }
    end
    backtrace do
      ['ActionView::Template::Error (ActionView::Template::Error):',
       'activesupport (3.0.7) lib/active_support/whiny_nil.rb:48:in `method_missing',
       'actionpack (3.0.7) lib/action_view/template.rb:135:in `block in render',
       'activesupport (3.0.7) lib/active_support/notifications.rb:54:in `instrument']
    end
  end
end
