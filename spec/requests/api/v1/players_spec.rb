# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Player', type: :request do
  before(:each) do
    post '/api/v1/games', params: { players: ['neo', 'henry'] }
    @game = JSON.parse(response.body)
  end

  describe 'GET /games/:game_id/players/:playerName' do
    it 'returns a player cards' do

      get "/api/v1/games/#{@game['game_id']}/players/neo"

      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(data).to have_key('cards')
    end
  end

  describe 'POST /games/:game_id/players/:playerName/fish' do
    it 'fishes for a card' do
      post "/api/v1/games/#{@game['game_id']}/players/neo/fish", params: { player: 'neo', rank: 'king' }

      data = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(data['catch']).to eq(true)
    end
  end
end
