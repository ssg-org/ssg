class IssuesController < ApplicationController
  def index
  	@issues = Issue.includes(:issue_updates).limit(20)
  end
end