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
    else
      options[:between] = (DateTime.now - 3.months)..DateTime.now
    end
    data = PostsByDow.series(options)
    min = PostsByDow.minimum(:day).to_i
    max = PostsByDow.maximum(:day).to_i
    render json: Oj.dump(data: data, min: min, max: max,
                         from: options[:between].min.to_i,
                         to: options[:between].max.to_i)
  end

  def pphod
    options = {}
    if (q = params[:posts_by_hod_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    else
      options[:between] = (DateTime.now - 3.months)..DateTime.now
    end
    data = PostsByHod.series(options)
    min = PostsByHod.minimum(:hour).to_i
    max = PostsByHod.maximum(:hour).to_i
    render json: Oj.dump(data: data, min: min, max: max,
                         from: options[:between].min.to_i,
                         to: options[:between].max.to_i)
  end
end
