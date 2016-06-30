require 'spec_helper'

feature 'Compression' do
  scenario 'a visitor has a browser that supports compression', :js do
    ['deflate','gzip', 'deflate,gzip','gzip,deflate'].each do |compression_method|
      page.driver.add_header('HTTP_ACCEPT_ENCODING', compression_method )
      visit root_path
      expect(page.response_headers.keys).to include('Content-Encoding')
    end
  end

  scenario 'a visitor has a browser that does not support compression' do
    visit root_path
    expect(page.response_headers.keys).not_to include('Content-Encoding')
  end
end
