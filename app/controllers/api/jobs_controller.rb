class Api::JobsController < ApplicationController
    before_action :authorize_request
    before_action :set_pueblo, only: [:index, :create]
    before_action :set_job,    only: [:show, :update, :destroy]
  
    def index
      scope = @pueblo.jobs
      scope = (current_user&.admin? || current_user&.host?) ? scope : scope.where(approved: true, status: 'open')
      render json: scope.order(created_at: :desc)
    end
  
    def create
      authorize_host
      job = @pueblo.jobs.new(job_params.merge(user_id: current_user.id, approved: false))
      if job.save
        render json: job, status: :created
      else
        render json: { errors: job.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      if @job.approved? || current_user&.admin? || @job.user_id == current_user&.id
        render json: @job
      else
        render json: { error: 'Not found' }, status: :not_found
      end
    end
  
    def update
      return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin? || @job.user_id == current_user.id
      if @job.update(job_params)
        render json: @job
      else
        render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin? || @job.user_id == current_user.id
      @job.destroy!
      head :no_content
    end
  
    private
    def set_pueblo = @pueblo = PuebloMagico.find(params[:pueblo_magico_id])
    def set_job    = @job    = Job.find(params[:id])
  
    def job_params
      params.require(:job).permit(:title, :company, :description, :status, :contact_email)
    end
  
    def authorize_host
      return if current_user&.host? || current_user&.admin?
      render json: { error: 'Forbidden' }, status: :forbidden and return
    end
  end
  