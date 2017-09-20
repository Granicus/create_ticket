require 'test_helper'

class CreateTicketTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CreateTicket::VERSION
  end

  def test_it_does_something_useful
    old_jira_url = ENV['JIRA_URL']
    ENV['JIRA_URL'] = 'testing'
    assert_equal 'testing', CreateTicket.jira_url
    ENV['JIRA_URL'] = old_jira_url
  end

  def test_it_loads_an_example_file
    old_variable = ENV['VARIABLE']
    ENV['VARIABLE'] = 'lol'
    old_template_filename = ENV['TEMPLATE_FILENAME']
    ENV['TEMPLATE_FILENAME'] = 'test/fixtures/example.md.erb'

    assert_equal 'HEY!', CreateTicket.summary

    expected_description = File.open('test/fixtures/example.confluence').read
    assert_equal expected_description, CreateTicket.description
  end
end
