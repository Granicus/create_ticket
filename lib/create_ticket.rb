# frozen_string_literal: true

require 'create_ticket/version'
require 'create_ticket/could_not_create_ticket_error'
require 'markdown2confluence'
require 'faraday'
require 'json'
require 'erb'

class CreateTicket
  extend Forwardable

  attr_reader :conf

  def initialize(conf)
    conf = OpenStruct.new(conf) if conf.is_a? Hash
    @conf = conf
  end

  def_delegators :conf,
                 :jira_url, :project, :jira_token, :template_filename,
                 :assignee, :issue_type, :duedate, :custom_fields

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

  def create_ticket!
    response = jira_request.post do |req|
      req.url '/rest/api/2/issue'
      req.body = jira_ticket_json
    end

    begin
      key = JSON.parse(response.body).fetch('key')
    rescue KeyError
      raise CouldNotCreateTicketError, "Response from JIRA was: #{response.body}"
    end

    "#{jira_url}/browse/#{key}"
  end

  def fields
    effs = {
      project: { key: project },
      issuetype: { name: issue_type },
      summary: summary,
      description: description,
      assignee: { name: assignee },
      reporter: { name: assignee }
    }.merge(custom_fields)
    effs[:duedate] = duedate unless duedate.nil?
    effs
  end

  def jira_ticket_json
    {
      fields: fields
    }.to_json
  end

  def content
    ERB.new(template).result(binding)
  end

  def summary
    # TODO: Assumes Markdown with an h1 at the top.
    content.lines.first[2..-1].strip
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
    # TODO: Assumes Markdown with an h1 at the top.
    markdown = content.sub(/# .*\n/, '')

    Kramdown::Document.new(markdown, kramdown_options).to_confluence
  end
end
