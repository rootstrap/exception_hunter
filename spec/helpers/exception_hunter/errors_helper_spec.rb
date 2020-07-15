module ExceptionHunter
  describe ErrorsHelper do
    extend ErrorsHelper

    describe '#format_tracked_data' do
      let(:tracked_data) do
        {
          something: 1,
          nested: [
            'abc',
            { email: 'example@email.com' }
          ]
        }
      end

      it 'returns a json string with correct indentation' do
        expect(format_tracked_data(tracked_data)).to eq("{\n  \"something\": 1,\n  \"nested\": [\n    \"abc\",\n    {\n      \"email\": \"example@email.com\"\n    }\n  ]\n}")
      end
    end
  end
end
