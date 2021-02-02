require 'rails_helper'

Rails.application.load_tasks

describe 'exception_hunter:purge_errors' do
  it 'calls the ErrorReaper purge method' do
    expect(::ExceptionHunter::ErrorReaper).to receive(:purge)

    Rake::Task['exception_hunter:purge_errors'].invoke
  end
end
