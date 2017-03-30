def stub_video
  stub_request(:get, 'https://api.vimeo.com/videos/132090907').
    with(headers: {
      'Accept': 'application/vnd.vimeo.*+json;version=3.2',
      'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization': 'bearer e578c524473e9e332cbf916a887b1e9a',
      'User-Agent': 'VideoInfo/2.7'
    }).
    to_return(
      status: 200,
      body: {
        string: {
          uri: '/videos/132090907',
          link: 'https://vimeo.com/132090907',
          duration: 999
        },
      }.to_json,
      headers: {}
    )
end
