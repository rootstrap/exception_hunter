module ExceptionHunter
  describe DashboardPresenter do
    describe '#current_tab' do
      it 'sets a default value when the tab is not valid' do
        presenter = DashboardPresenter.new('some_random_tab')
        expect(presenter.current_tab).to eq(DashboardPresenter::DEFAULT_TAB)
      end

      it 'sets a default value when the tab is nil' do
        presenter = DashboardPresenter.new(nil)
        expect(presenter.current_tab).to eq(DashboardPresenter::DEFAULT_TAB)
      end
    end

    describe '#partial_for_tab' do
      it 'returns a value for each valid tab' do
        DashboardPresenter::TABS.each do |tab|
          presenter = DashboardPresenter.new(tab)
          expect(presenter.partial_for_tab).not_to be_nil
        end
      end
    end

    describe '#tab_active?' do
      it 'returns true when the tab is active' do
        presenter = DashboardPresenter.new(DashboardPresenter::TOTAL_ERRORS_TAB)
        expect(presenter.tab_active?(DashboardPresenter::TOTAL_ERRORS_TAB)).to be true
      end

      it 'returns false when the tab is not active' do
        presenter = DashboardPresenter.new(DashboardPresenter::TOTAL_ERRORS_TAB)
        expect(presenter.tab_active?(DashboardPresenter::CURRENT_MONTH_TAB)).to be false
      end
    end

    describe '#errors_count' do
      it 'returns a value for each valid tab' do
        presenter = DashboardPresenter.new(DashboardPresenter::CURRENT_MONTH_TAB)
        DashboardPresenter::TABS.each do |tab|
          expect(presenter.errors_count(tab)).not_to be_nil
        end
      end
    end
  end
end
