class IssuesController < ApplicationController
  before_action :admin_required
  layout "admin"
  before_action -> {set_title "Numery rocznika"}

  def index
    @query_params = params[:q] || {}
    @query = Issue.ransack(@query_params)
    @query.sorts = ['year desc','volume desc'] if @query.sorts.empty?
    @issues = @query.result(distinct: true)
  end


  def publish
    @issue = find_issue
    @issue.publish
    redirect_to @issue
  end

  def new
    @issue = Issue.new
  end

  def prepare_form
    @issue = find_issue
  end

  def prepare
    @issue = Issue.find_by_volume(params[:id])
    if params[:issue][:submission_ids] && @issue.prepare_to_publish(params[:issue][:submission_ids])
      redirect_to @issue
    else
      render :prepare_form
    end
  end

  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      redirect_to @issue
    else
      render :new
    end
  end

  def edit
    @issue = find_issue
  end

  def update
    @issue = Issue.find_by_volume(params[:id])
    if @issue.update_attributes(issue_params)
      redirect_to @issue
    else
      render :edit
    end
  end

  def show
    @issue = find_issue
  end

  def summary
    @issue = find_issue
  end


  def show_reviews
    @issue = find_issue
  end

  def show_statistics
    @issue = find_issue
  end

  def show_reviewers
    @issue = find_issue
  end

  def table_of_contents
    @issue = find_issue
  end

  private

  def issue_params
    params.require(:issue).permit(:year,:volume)
  end

  def find_issue
    Issue.find_by_volume(params[:id])
  end

end
