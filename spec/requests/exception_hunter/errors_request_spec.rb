require 'rails_helper'

module ExceptionHunter
  describe 'Errors', type: :request do
    describe 'GET /exception_hunter/errors' do
      subject { get "/exception_hunter/errors?tab=#{tab}" }

      context 'in the last 7 days tab' do
        let(:tab) { DashboardPresenter::LAST_7_DAYS_TAB }
        let(:shown_errors) do
          [
            create(:error_group, message: 'Group 1'),
            create(:error_group, message: 'Group 2'),
            create(:error_group, message: 'Group 3')
          ]
        end
        let(:hidden_errors) do
          [
            create(:error_group, message: 'Group 4'),
            create(:error_group, message: 'Group 5')
          ]
        end

        before do
          create(:error, error_group: shown_errors.first, occurred_at: Date.current)
          create(:error, error_group: shown_errors.second, occurred_at: 3.days.ago)
          create(:error, error_group: shown_errors.third, occurred_at: 6.days.ago)

          create(:error, error_group: hidden_errors.first, occurred_at: 8.days.ago)
          create(:error, error_group: hidden_errors.second, occurred_at: 1.month.ago)
        end

        it 'renders the index template' do
          subject

          expect(response).to render_template(:index)
        end

        it 'shows date groups' do
          subject

          expect(response.body).to include('Yesterday')
          expect(response.body).to include(ErrorGroupPresenter.format_occurrence_day(2.days.ago))
        end

        it 'shows the valid groups' do
          subject

          shown_errors.each do |group|
            expect(response.body).to include(group.message)
          end
        end

        it 'does not show invalid groups' do
          subject

          hidden_errors.each do |group|
            expect(response.body).not_to include(group.message)
          end
        end
      end

      context 'in the current month tab' do
        let(:tab) { DashboardPresenter::CURRENT_MONTH_TAB }
        let(:shown_errors) do
          [
            create(:error_group, message: 'Group 1'),
            create(:error_group, message: 'Group 2'),
            create(:error_group, message: 'Group 3')
          ]
        end
        let(:hidden_errors) do
          [
            create(:error_group, message: 'Group 4'),
            create(:error_group, message: 'Group 5')
          ]
        end

        before do
          create(:error, error_group: shown_errors.first, occurred_at: Date.current)
          create(:error, error_group: shown_errors.second, occurred_at: Date.current.beginning_of_month + 15.days)
          create(:error, error_group: shown_errors.third, occurred_at: Date.current.beginning_of_month)

          create(:error, error_group: hidden_errors.first, occurred_at: 32.days.ago)
          create(:error, error_group: hidden_errors.second, occurred_at: 2.months.ago)
        end

        it 'renders the index template' do
          subject
          expect(response).to render_template(:index)
        end

        it 'shows the valid groups' do
          subject

          shown_errors.each do |group|
            expect(response.body).to include(group.message)
          end
        end

        it 'does not show invalid groups' do
          subject

          hidden_errors.each do |group|
            expect(response.body).not_to include(group.message)
          end
        end
      end

      context 'in the total errors tab' do
        let(:tab) { DashboardPresenter::TOTAL_ERRORS_TAB }
        let(:shown_errors) do
          [
            create(:error_group, message: 'Group 1'),
            create(:error_group, message: 'Group 2'),
            create(:error_group, message: 'Group 3'),
            create(:error_group, message: 'Group 4'),
            create(:error_group, message: 'Group 5')
          ]
        end

        before do
          create(:error, error_group: shown_errors.first, occurred_at: Date.current)
          create(:error, error_group: shown_errors.second, occurred_at: 15.days.ago)
          create(:error, error_group: shown_errors.third, occurred_at: Date.current.beginning_of_month)
          create(:error, error_group: shown_errors.first, occurred_at: 32.days.ago)
          create(:error, error_group: shown_errors.second, occurred_at: 2.months.ago)
        end

        it 'renders the index template' do
          subject
          expect(response).to render_template(:index)
        end

        it 'shows the valid groups' do
          subject

          shown_errors.each do |group|
            expect(response.body).to include(group.message)
          end
        end
      end

      context 'in the resolved errors tab' do
        let(:tab) { DashboardPresenter::RESOLVED_ERRORS_TAB }

        it 'renders the index template' do
          subject
          expect(response).to render_template(:index)
        end
      end
    end

    describe 'GET /exception_hunter/errors/:id' do
      let(:error_group) { create(:error_group) }

      subject { get "/exception_hunter/errors/#{error_group.id}" }

      before do
        create_list(:error, 2, error_group: error_group)
      end

      it 'renders the show template' do
        subject

        expect(response).to render_template(:show)
      end
    end

    describe 'DELETE /exception_hunter/errors/purge' do
      subject { delete '/exception_hunter/errors/purge' }

      it 'calls the ErrorReaper' do
        expect(ErrorReaper).to receive(:purge)

        subject
      end

      it 'redirects back' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end
end
