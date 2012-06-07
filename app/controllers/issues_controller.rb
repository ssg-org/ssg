class IssuesController < ApplicationController
  def index
  	@issues = Issue.includes(:issue_updates, :attachments).limit(20)
  end
end