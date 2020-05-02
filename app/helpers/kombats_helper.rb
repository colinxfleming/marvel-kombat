module KombatsHelper
  def display(result)
    return same_thing if result == KombatLogic::IDENTICAL
  end

  private

  def same_thing
    safe_join([
      content_tag(:p, 'Same hero?'),
      image_tag('spiderman-pointing-spiderman.jpg')
    ])
  end
end
