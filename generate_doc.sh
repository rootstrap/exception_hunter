bundle exec yard doc \
  --hide-void-return \
  --no-private \
  --embed-mixin ExceptionHunter::Tracking \
  --exclude '(app|lib/generators|lib/devise)'
