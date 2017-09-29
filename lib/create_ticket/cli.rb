# frozen_string_literal: true

class CreateTicket
  class Cli
    def conf
      {
        jira_url: ENV.fetch('JIRA_URL'),
        project: ENV.fetch('JIRA_PROJECT'),
        jira_token: ENV.fetch('JIRA_TOKEN'),
        template_filename: ENV.fetch('TEMPLATE_FILENAME'),
        assignee: ENV.fetch('JIRA_ASSIGNEE'),
        issue_type: ENV.fetch('JIRA_ISSUE_TYPE')
      }
    end

    def run!
      CreateTicket.new(conf).create_ticket!
    end
  end
end
