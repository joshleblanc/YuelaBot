# frozen_string_literal: true

class ProfileButtonComponent < ApplicationComponent
  def container(opts = {}, &blk)
    if helpers.current_user
      link_to profile_edit_url, opts, &blk
    else
      button_to "/auth/discord", opts, &blk
    end
  end
end
