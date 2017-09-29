# frozen_string_literal: true

require 'create_ticket/version'
require 'markdown2confluence'
require 'faraday'
require 'json'
require 'erb'

class CreateTicket
  attr_reader :jira_url, :project, :jira_token, :template_filename, :assignee, :issue_type

  def initialize(conf)
    @jira_url = conf.fetch(:jira_url)
    @project = conf.fetch(:project)
    @jira_token = conf.fetch(:jira_token)
    @template_filename = conf.fetch(:template_filename)
    @assignee = conf.fetch(:assignee)
    @issue_type = conf.fetch(:issue_type)
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

  def create_ticket!
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

  def content
    ERB.new(template).result(binding)
  rescue KeyError => e
    puts "Please set all required ENV variables for your template: #{ENV['TEMPLATE_FILENAME']}"
    puts e.message
    exit 1
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
