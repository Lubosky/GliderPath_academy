require 'spec_helper'

describe ApplicationHelper do
  describe '#format_markdown' do
    it 'returns the rendered html for the input markdown' do
      content = 'hello **world**'

      formatted = helper.format_markdown(content)

      expect(formatted).to eq("<p>hello <strong>world</strong></p>")
    end

    it 'returns the rendered emoji for the input markdown' do
      content = '**Smile like you mean it** :smile:'

      formatted = helper.format_markdown(content)

      expect(formatted).to have_css("img[class*='emoji']")
    end

    it 'returns the rendered code block for the input markdown' do
      content = "```ruby\nrequire 'spec_helper'\n```"

      formatted = helper.format_markdown(content)

      expect(formatted).to have_css("pre[class*='highlight-ruby']")
    end

    context 'with an empty input' do
      it 'returns an empty string' do
        expect(helper.format_markdown(nil)).to eq('')
      end
    end
  end
end
