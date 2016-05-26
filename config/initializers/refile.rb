require 'refile/simple_form'

Refile.cache = Refile::Backend::FileSystem.new('tmp/uploads/cache', max_size: 5.megabytes)
Refile.store = Refile::Backend::FileSystem.new('tmp/uploads/store')
