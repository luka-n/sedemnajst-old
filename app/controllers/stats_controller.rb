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
    if (q = params[:posts_by_dow_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    end
    data = PostsByDow.series(options)
    min = Post.minimum(:remote_created_at).to_i
    max = Post.maximum(:remote_created_at).to_i
    render json: Oj.dump(data: data, min: min, max: max)
  end

  def pphod
    options = {}
    if (q = params[:posts_by_hod_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    end
    data = PostsByHod.series(options)
    min = Post.minimum(:remote_created_at).to_i
    max = Post.maximum(:remote_created_at).to_i
    render json: Oj.dump(data: data, min: min, max: max)
  end
end
