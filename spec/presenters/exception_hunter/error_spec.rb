require 'rails_helper'

module ExceptionHunter
  describe ErrorPresenter do
    let(:error_presenter) { ErrorPresenter.new(error) }

    describe '#backtrace' do
      subject { error_presenter.backtrace }

      context 'when the line matches the expected format' do
        let(:error) do
          create(:error, backtrace: [
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
          create(:error, backtrace: [
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
