# frozen_string_literal: true

require 'test_helper'

class CreateTicketTest < Minitest::Test
  def example_conf
    {
      jira_url: 'jira_url',
      project: 'project',
      jira_token: 'jira_token',
      template_filename: 'test/fixtures/example.md.erb',
      assignee: 'assignee',
      issue_type: 'issue_type',
      duedate: nil,
      custom_fields: {
        'customfield_123': 'lol',
        'customfield_456': 'zomg'
      }
    }
  end

  def expected_fields
    {
      project: { key: 'project' },
      issuetype: { name: 'issue_type' },
      summary: 'HEY!',
      description: expected_description,
      assignee: { name: 'assignee' },
      reporter: { name: 'assignee' },
      duedate: nil,
      customfield_123: 'lol',
      customfield_456: 'zomg'
    }
  end

  def expected_description
    File.open('test/fixtures/example.confluence').read
  end

  def ticket_creator
    @ticket_creator ||= CreateTicket.new(example_conf)
  end

  def test_that_it_has_a_version_number
    refute_nil ::CreateTicket::VERSION
  end

  def test_it_configures_fields_correctly
    ENV['VARIABLE'] = 'lol'

    assert_equal expected_fields, ticket_creator.fields
  end
end
