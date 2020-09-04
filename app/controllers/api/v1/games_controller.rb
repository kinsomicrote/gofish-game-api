# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      def create
        @game = ::V1::DeckService.new.new_game(params)
        render json: @game, status: 201
      end
    end
  end
end