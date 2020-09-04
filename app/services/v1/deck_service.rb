# frozen_string_literal: true

module V1
  class DeckService
    def new_game(params)
      game = HTTParty.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').parsed_response
      params[:players].each do |player|
        add_to_pile({ game_id: game['deck_id'], player: player, count: 7 })
      end
      { game_id: game['deck_id'], players: params[:players] }
    end

    def draw_card_from_deck(params)
      response = HTTParty.get("https://deckofcardsapi.com/api/deck/#{params[:game_id]}/draw/?count=#{params[:count]}")
      response['cards'] if response['success']
    end

    def add_to_pile(params)
      drawn_cards = draw_card_from_deck({ game_id: params[:game_id], count: params[:count] })
      url = "https://deckofcardsapi.com/api/deck/#{params[:game_id]}/pile/#{params[:player]}/add/?cards="
      drawn_cards.each do |card|
        url = "#{url},#{card['code']}"
      end
      HTTParty.get(url)
    end
  end
end
