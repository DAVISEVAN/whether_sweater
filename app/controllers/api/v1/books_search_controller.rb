class Api::V1::BooksSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i

    if quantity <= 0
      render json: { error: 'Quantity must be a positive integer greater than 0' }, status: :bad_request
      return
    end

    books_search_data = BooksSearchFacade.fetch_data(location, quantity)

    if books_search_data[:error]
      render json: { error: books_search_data[:error] }, status: :bad_request
    else
      render json: BookSearchSerializer.new(location, books_search_data[:forecast], books_search_data[:books]).serialize_response
    end
  end
end
