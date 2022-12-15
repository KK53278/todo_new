class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to root_path
    else
      render 'edit', status: :unprocessable_entity
                    # バリデーションエラーの場合に返す
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_path, status: :see_other
    # 303 See Other 確認ページなど別なページにリンクする
  end
  
  # リロードしてもcheck boxの状態が保持される
  def toggle
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed)
    render turbo_stream: turbo_stream.replace(
      @task,
      partial: 'completed',
      locals: { task: @task}
      )
  end

  private

  def task_params
    params.require(:task).permit(:title)
  end
  
end
