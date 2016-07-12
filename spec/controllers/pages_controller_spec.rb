require 'spec_helper'

RSpec.describe PagesController, type: :controller do

  %w(contact faq home privacy terms).each do |page|
    describe "GET ##{page}" do
      before do
        get "#{page}"
      end
      it {
        is_expected.to respond_with :ok
        is_expected.to render_with_layout :page
        is_expected.to render_template "#{page}"
      }
    end
  end

end
