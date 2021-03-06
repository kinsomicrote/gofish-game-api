# frozen_string_literal: true

module Api
  module V1
    class PlayersController < ApplicationController
      def show
        player = ::V1::DeckService.new.player_cards(params)
        render json: player, status: 200
      end

      def fish
        result = ::V1::DeckService.new.fish(params)
        render json: result, status: 201
      end
    end
  end
end
