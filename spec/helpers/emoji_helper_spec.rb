require 'spec_helper'

describe EmojiHelper do
  describe '#emojify' do
    it 'returns the rendered emoji for the input markdown' do
      content = '**Smile like you mean it** :smile:'

      formatted = helper.emojify(content)

      expect(formatted).to have_css("img[class*='emoji']")
    end
  end
end
