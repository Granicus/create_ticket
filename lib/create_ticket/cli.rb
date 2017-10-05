# frozen_string_literal: true

require 'create_ticket'

class CreateTicket
  class CLI
    def jira_url
      ENV.fetch('JIRA_URL')
    end

    def project
      ENV.fetch('JIRA_PROJECT')
    end

    def jira_token
      ENV.fetch('JIRA_TOKEN')
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
      CreateTicket.new(self).create_ticket!
    end
  end
end
