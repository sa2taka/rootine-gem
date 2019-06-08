# frozen_string_literal: true

RSpec.describe RootineGem do
  describe '#find_roots' do
    it 'find roots' do
      rootine = RootineGem::Rootine.new
      expected = [[0, 4, [331]], [4, 7, [64]], [7, 10, [215]], [10, 12, [38, 39, 40]]]
      actual = rootine.get_word_roots('telecommuter')
      expect(actual).to eq expected
    end
  end
end
