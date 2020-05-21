module ExceptionHunter
  describe ErrorReaper do
    describe '.purge' do
      subject { described_class.purge(delete_until: deadline) }
      let(:deadline) { 1.month.ago }

      let(:error_group) { create(:error_group) }
      let!(:old_errors) do
        3.times.map { |i| create(:error, occurred_at: (1 + i).months.ago - 1.week, error_group: error_group) }
      end
      let!(:new_errors) do
        2.times.map { |i| create(:error, occurred_at: (1 + i).weeks.ago, error_group: error_group) }
      end

      let!(:empty_error_group) { create(:error_group) }

      let(:only_old_errors_error_group) { create(:error_group) }
      let!(:old_error) { create(:error, occurred_at: 5.weeks.ago, error_group: only_old_errors_error_group) }

      it 'deletes errors with old occurrences' do
        expect { subject }.to change(Error, :count).by(-4)
        expect(Error.where(id: [old_error.id].concat(old_errors.map(&:id)))).not_to exist
      end

      it 'does not delete errors with new occurrences' do
        subject

        expect(Error.where(id: new_errors.map(&:id))).to exist
      end

      it 'deletes error groups with no associated errors' do
        expect { subject }.to change(ErrorGroup, :count).by(-2)
        expect(ErrorGroup.where(id: empty_error_group.id)).not_to exist
      end

      it 'does not delete error groups with associated errors' do
        subject

        expect(ErrorGroup.where(id: error_group.id)).to exist
      end

      it 'deletes error groups which have all associated errors with old occurrences' do
        subject

        expect(ErrorGroup.where(id: only_old_errors_error_group.id)).not_to exist
      end
    end
  end
end
