# Installing database_cleaner:

# 1. Add database_cleaner to Gemfile:
#
# group :test do
#   gem 'database_cleaner'
# end

# 2. IMPORTANT! Delete the "config.use_transactional_fixtures = ..." line
#    in spec/rails_helper.rb (we're going to configure it in this file you're
#    reading instead).

# 3. Create a file like this one you're reading in spec/support/database_cleaner.rb:
RSpec.configure do |config|

  config.use_transactional_fixtures = false

  # This says that before the entire test suite runs, clear the test database
  # out completely. This gets rid of any garbage left over from interrupted or
  # poorly-written tests—a common source of surprising test behavior
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # This part sets the default database cleaning strategy to be transactions.
  # Transactions are very fast, and for all the tests where they do work—that
  # is, any test where the entire test runs in the RSpec process—they are preferable.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # This line only runs before examples which have been flagged :js => true.
  # By default, these are the only tests for which Capybara fires up a test
  # server process and drives an actual browser window via the Selenium backend.
  # For these types of tests, transactions won’t work, so this code overrides the
  # setting and chooses the “truncation” strategy instead.
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  # These lines hook up database_cleaner around the beginning and end of each
  # test, telling it to execute whatever cleanup strategy we selected beforehand.
  config.before(:each) do
    DatabaseCleaner.start
  end


  config.after(:each) do
    DatabaseCleaner.clean
  end

end

# Suggested docs
# --------------
# http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
