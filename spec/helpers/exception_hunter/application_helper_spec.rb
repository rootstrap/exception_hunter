module ExceptionHunter
  describe ::ExceptionHunter::ApplicationHelper do
    extend ::ExceptionHunter::ApplicationHelper

    describe '#application_name' do
      it 'returns a name of parent module' do
        expect(application_name).to eq('Dummy')
      end
    end
  end
end
