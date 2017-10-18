# frozen_string_literal: true

require 'base64'
require 'highline'
require 'create_ticket'

class CreateTicket
  class CLI
    def jira_url
      ENV.fetch('JIRA_URL')
    end

    def project
      ENV.fetch('JIRA_PROJECT')
    end

    def prompt_for_jira_token
      cli = HighLine.new
      username = cli.ask('Username: ')
      password = cli.ask('Password: ') { |q| q.echo = '*' }
      Base64.encode64 "#{username}:#{password}"
    end

    def jira_token
      ENV.fetch('JIRA_TOKEN', prompt_for_jira_token)
    end

    def template_filename
      ENV.fetch('TEMPLATE_FILENAME')
    end

    def assignee
      ENV.fetch('JIRA_ASSIGNEE')
    end

    def issue_type
      ENV.fetch('JIRA_ISSUE_TYPE')
    end

    def custom_fields
      ENV.select { |k, _| k.start_with? 'JIRA_CUSTOMFIELD' }.to_a
         .map { |k, v| [k.downcase.sub(/^jira_/, ''), v] }.to_h
    end

    def duedate
      ENV['JIRA_DUEDATE']
    end

    def run!
      ticket_url = CreateTicket.new(self).create_ticket!
      puts ticket_url
    rescue KeyError, JSON::ParserError => e
      puts e.message
      exit 1
    end
  end
end
