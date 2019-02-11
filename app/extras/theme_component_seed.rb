# sorry mom :(
class Mingle::ThemeComponentSeed
  def seed!
    seed_admin_theme! unless mingle_theme
    seed_relations!
  end

  def reseed!
    mingle_theme&.destroy
    seed!
  end

  private

  def mingle_theme
    Theme.find_by(id: SiteSetting.mingle_theme_id)
  end

  def seed_admin_theme!
    SiteSetting.mingle_theme_id = Theme.create!(
      name: :mingle_admin_theme,
      user_id: -1,
      hidden: true
    ).tap do |theme|
      theme.theme_fields.create!(
        name: :head_tag,
        target_id: Theme.targets[:common],
        value: open(Rails.root.join('plugins', 'mingle', 'assets', 'themes', 'mingle-theme.hbs')).read
      )
    end.id
  end

  def seed_relations!
    Theme.where.not(id: ChildTheme.pluck(:child_theme_id)).each do |parent|
      ChildTheme.find_or_create_by(parent_theme: parent, child_theme: mingle_theme)
    end
  end
end
