# frozen_string_literal: true

require 'test_helper'

class CreateTicketTest < Minitest::Test
  def test_conf
    {
      jira_url: 'jira_url',
      project: 'project',
      jira_token: 'jira_token',
      template_filename: 'test/fixtures/example.md.erb',
      assignee: 'assignee',
      issue_type: 'issue_type'
    }
  end

  def test_create_ticket
    @test_create_ticket ||= CreateTicket.new(test_conf)
  end

  def test_that_it_has_a_version_number
    refute_nil ::CreateTicket::VERSION
  end

  def test_it_uses_supplied_conf
    assert_equal 'jira_url', test_create_ticket.jira_url
    assert_equal 'project', test_create_ticket.project
    assert_equal 'jira_token', test_create_ticket.jira_token
    assert_equal 'assignee', test_create_ticket.assignee
    assert_equal 'issue_type', test_create_ticket.issue_type
  end

  def test_it_loads_an_example_file
    ENV['VARIABLE'] = 'lol'

    assert_equal 'HEY!', test_create_ticket.summary

    expected_description = File.open('test/fixtures/example.confluence').read
    assert_equal expected_description, test_create_ticket.description
  end
end
