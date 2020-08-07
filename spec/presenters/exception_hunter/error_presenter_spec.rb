require 'rails_helper'

module ExceptionHunter
  describe ErrorPresenter do
    let(:error_presenter) { ErrorPresenter.new(error) }

    describe '#environment_data' do
      subject { error_presenter.environment_data }

      context 'when the error has environment data' do
        let(:error) do
          create(:error,
                 environment_data: {
                   'something' => 123,
                   'something_else' => 'abcd',
                   'params' => {
                     'name' => 'John'
                   }
                 })
        end

        it 'returns the error environment data without the params' do
          expect(subject).to eq({ 'something' => 123, 'something_else' => 'abcd' })
        end
      end

      context 'when the error does not have environment data' do
        let(:error) { create(:error, environment_data: nil) }

        it 'returns an empty hash' do
          expect(subject).to eq({})
        end
      end
    end

    describe '#tracked_params' do
      subject { error_presenter.tracked_params }

      context 'when the environment data has tracked params' do
        let(:error) do
          create(:error,
                 environment_data: {
                   'something' => 123,
                   'something_else' => 'abcd',
                   'params' => {
                     'name' => 'John'
                   }
                 })
        end

        it 'returns those tracked params' do
          expect(subject).to eq({ 'name' => 'John' })
        end
      end

      context 'when the environment data does not have tracked params' do
        let(:error) { create(:error, environment_data: { 'something' => 123 }) }

        it { is_expected.to be_nil }
      end
    end

    describe '#backtrace' do
      subject { error_presenter.backtrace }

      context 'when the line matches the expected format' do
        let(:error) do
          create(:error, backtrace:
            [
              "activesupport (3.0.7) lib/active_support/whiny_nil.rb:48:in `method_missing'",
              "actionpack (3.0.7) lib/action_view/template.rb:135:in `block in render'"
            ])
        end

        it 'returns the line presented' do
          expect(subject).to all be_a(ErrorPresenter::BacktraceLine)
        end

        it 'returns the different parts of the line' do
          built_lines = subject.map do |line|
            "#{line.path}/#{line.file_name}:#{line.line_number}:in `#{line.method_call}'"
          end

          expect(built_lines).to match_array(error.backtrace)
        end
      end

      # this is just to prevent unknown failures, no cases
      # have been found where this would actually happen
      context 'when the line does not match the expected format' do
        let(:error) do
          create(:error, backtrace:
            [
              'some unexpected path path',
              'will this even happen? better be safe'
            ])
        end

        it 'returns the line' do
          expect(subject).to match_array(error.backtrace)
        end
      end
    end
  end
end
