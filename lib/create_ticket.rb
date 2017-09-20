require 'create_ticket/version'
require 'markdown2confluence'
require 'faraday'
require 'json'
require 'erb'

module CreateTicket
  extend self

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

  def template
    @template ||= File.open(template_filename).read
  end

  def jira_request
    Faraday.new(url: jira_url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
      faraday.headers['Authorization'] = 'Basic ' + jira_token
    end
  end

  def create_ticket
    response = jira_request.post do |req|
      req.url '/rest/api/2/issue'
      req.body = jira_ticket_json
    end
    key = JSON.parse(response.body).fetch('key')
    puts "#{jira_url}/browse/#{key}"
  end

  def jira_ticket_json
    {
      fields: {
        project: { key: project },
        issuetype: { name: issue_type },
        summary: summary,
        description: description,
        assignee: { name: assignee },
        reporter: { name: assignee }
      }
    }.to_json
  end

  def summary
    # TODO: Assumes Markdown with an h1 at the top.
    template.lines.first[2..-1].strip
  end

  def kramdown_options
    {
      input: 'GFM',
      syntax_highlighter: 'coderay',
      syntax_highlighter_opts: {
        css: 'style',
        line_numbers: 'table'
      }
    }
  end

  def description
    markdown = ERB.new(template).result(binding)

    # TODO: Assumes Markdown with an h1 at the top.
    markdown.sub!(/# .*\n/, '')

    Kramdown::Document.new(markdown, kramdown_options).to_confluence
  end
end
