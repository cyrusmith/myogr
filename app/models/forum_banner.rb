require "ipb_forum/connect/connectable"

class ForumBanner < Banner
  extend Forum::Connectable

  def activate
    generate_banner
    add_to_forum
    super
  end

  def deactivate
    remove_from_forum
    super
  end

  private

  # Generate HTML banner for forum
  def generate_banner
  end

  #Connect to forum and add banner
  def add_to_forum
  end

  #Connect to forum and remove banner
  def remove_from_forum
  end

end