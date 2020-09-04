# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Player', type: :request do
  describe 'GET /games/:game_id/players/:playerName' do
    it 'returns a player cards' do
      post '/api/v1/games', params: { players: ['neo', 'henry'] }
      game = JSON.parse(response.body)

      get "/api/v1/games/#{game['game_id']}/players/neo"

      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(data).to have_key('cards')
    end
  end
end
