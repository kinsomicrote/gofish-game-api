# frozen_string_literal: true

module V1
  class DeckService
    RANK = { "2" => "two", "3" => "three", "4" => "four", "5" => "five", "6" => "six", "7" => "seven", "8" => "eight",
             "9" => "nine", "10" => "ten", "KING" => "king", "ACE" => "ace", "JACK" => "jack", "QUEEN" => "queen" }.freeze

    def new_game(params)
      game = HTTParty.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1').parsed_response
      params[:players].each do |player|
        build_player_pile({ game_id: game['deck_id'], player: player, count: 7 })
      end
      { game_id: game['deck_id'], players: params[:players] }
    end

    def build_player_pile(params)
      response = draw_card_from_deck({ game_id: params[:game_id], count: params[:count] })
      add_to_pile({ game_id: params[:game_id], player: params[:player], cards: response })
    end

    def draw_card_from_deck(params)
      response = HTTParty.get("https://deckofcardsapi.com/api/deck/#{params[:game_id]}/draw/?count=#{params[:count]}")
      response['cards'] if response['success']
    end

    def add_to_pile(params)
      url = "https://deckofcardsapi.com/api/deck/#{params[:game_id]}/pile/#{params[:player]}/add/?cards="
      params[:cards].each do |card|
        url = "#{url},#{card['code']}"
      end
      HTTParty.get(url)
    end

    def get_cards(params)
      response = HTTParty.get("https://deckofcardsapi.com/api/deck/#{params[:game_id]}/pile/#{params[:playerName]}/list")
      response['piles'][params[:playerName]]['cards'] if response['success']
    end

    def player_cards(params)
      response = get_cards(params)
      data = {}
      data[:cards] = response.map do |card|
        { rank: RANK[card['value']], suit: card['suit'].downcase }
      end
      data
    end

    def draw_from_player(params)
      response = HTTParty.get("https://deckofcardsapi.com/api/deck/#{params[:game_id]}/pile/#{params[:playerName]}/draw/?cards=#{params[:card]['code']}")
      response['cards'] if response['success']
    end

    def sort_card(params)
      response = get_cards(params)
      response.each do |card|
        next unless card['value'] == RANK.invert[params[:rank]]

        card = draw_from_player({ game_id: params[:game_id], playerName: params[:playerName], card: card })
        return card
      end
      nil
    end

    def fish(params)
      sorted_card = sort_card( { game_id: params[:game_id], playerName: params[:player], rank: params[:rank] })
      card = sorted_card.nil? ? draw_card_from_deck({ game_id: params[:game_id], count: 1 }) : sorted_card
      response = add_to_pile({ player: params[:playerName], game_id: params[:game_id], cards: card })
      return unless response['success']

      {
          catch: true,
          cards: [
              {
                  suit: card[0]['suit'],
                  rank: RANK[card[0]['value']]
              }
          ]
      }
    end
  end
end
