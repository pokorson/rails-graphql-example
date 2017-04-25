class GraphqlController < ApplicationController
  def query
    query_string = params[:query]
    render json: Schema.execute(query_string)
  end
end
