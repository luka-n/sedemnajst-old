class StatsController < ApplicationController
  def index
    @title = "dogajanje"
  end

  def pph
    data = PostsByHour.series
    render json: Oj.dump(data)
  end

  def ppdow
    options = {}
    options[:between] = if (q = params[:posts_by_dow_q])
                          Date.parse(q[:day_gteq])..Date.parse(q[:day_lteq])
                        else
                          (Date.today - 3.months)..Date.today
                        end
    render json: Oj.
      dump(data: PostsByDow.series(options),
           min: PostsByDow.minimum(:day).to_time(:utc).to_i * 1000,
           max: Date.today.to_time(:utc).to_i * 1000,
           from: options[:between].min.to_time(:utc).to_i * 1000,
           to: options[:between].max.to_time(:utc).to_i * 1000)
  end

  def pphod
    options = {}
    options[:between] = if (q = params[:posts_by_hod_q])
                          Date.parse(q[:day_gteq])..Date.parse(q[:day_lteq])
                        else
                          (Date.today - 3.months)..Date.today
                        end
    render json: Oj.
      dump(data: PostsByHod.series(options),
           min: PostsByHod.minimum(:day).to_time(:utc).to_i * 1000,
           max: Date.today.to_time(:utc).to_i * 1000,
           from: options[:between].min.to_time(:utc).to_i * 1000,
           to: options[:between].max.to_time(:utc).to_i * 1000)
  end
end
