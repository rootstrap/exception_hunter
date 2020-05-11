FactoryBot.define do
  factory :error, class: 'ExceptionHunter::Error' do
    class_name { 'ExceptionName' }
    message { 'Exception message' }
    occurred_at { '2020-03-25 10:27:33' }
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
      ["/Users/user/RailsProjects/exception_hunter/spec/dummy/app/controllers/exception_controller.rb:3:in `raising_endpoint'",
       "/Users/user/.rvm/rubies/ruby-2.6.5/lib/ruby/gems/2.6.0/gems/actionpack-6.0.2.2/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'",
       "/Users/user/.rvm/rubies/ruby-2.6.5/lib/ruby/gems/2.6.0/gems/actionpack-6.0.2.2/lib/abstract_controller/base.rb:196:in `process_action'",
       "/Users/user/.rvm/rubies/ruby-2.6.5/lib/ruby/gems/2.6.0/gems/actionpack-6.0.2.2/lib/action_controller/metal/rendering.rb:30:in `process_action'",
       "/Users/user/.rvm/rubies/ruby-2.6.5/lib/ruby/gems/2.6.0/gems/actionpack-6.0.2.2/lib/abstract_controller/callbacks.rb:42:in `block in process_action'",
       "/Users/user/.rvm/rubies/ruby-2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:135:in `run_callbacks'"]
    end

    association(:error_group)
  end
end
