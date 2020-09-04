# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game', type: :request do
  describe 'POST /api/v1/games' do
    it 'creates a new game' do
      post '/api/v1/games', params: { players: ['neo', 'henry'] }
      new_game = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(new_game).to have_key('game_id')
    end
  end
end
