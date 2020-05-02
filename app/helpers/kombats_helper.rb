module KombatsHelper
  def display(result)
    return same_thing if result[:outcome] == KombatLogic::IDENTICAL
    return display_tie(result) if result[:outcome] == KombatLogic::TIE
    return display_error(result) if result[:outcome] == KombatLogic::ERROR
    display_winner(result)
  end

  private

  def same_thing
    safe_join([
      content_tag(:p, 'Same hero!'),
      image_tag('spiderman-pointing-spiderman.jpg')
    ])
  end

  def display_winner(result)
    # Ternaries here are pretty brittle
    winner = result[:outcome] == 1 ? result[:hero_1] : result[:hero_2]
    loser = result[:outcome] == 1 ? result[:hero_2] : result[:hero_1]
    safe_join([
      content_tag(:p, "#{winner[:name]} has defeated #{loser[:name]}!"),
      content_tag(:p, " The galaxy is at peace.")
    ])
  end

  def display_tie(result)
    safe_join([
      content_tag(:p, "#{result[:hero_1][:name]} and #{result[:hero_2][:name]} are equally powerful in this matchup.")
    ]) 
  end

  def display_error(result)
    safe_join([
      content_tag(:p, 'Sorry, we hit an error getting character information.'),
      content_tag(:p, "Error detail from service: #{result[:reason]}")
    ])
  end
end
