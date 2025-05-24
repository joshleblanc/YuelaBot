# frozen_string_literal: true

class ProfileButtonComponent < ApplicationComponent
  def container(opts = {})
    if helpers.current_user
      link_to profile_edit_url, opts do
        yield
      end
    else
      button_to "/auth/discord", opts do
        yield
      end
    end
  end

  render do
    container data: { turbo: false } do
      div class: "inline-flex items-center relative border-2 px-2 rounded-full hover:shadow-lg text-white" do
        if current_user
          text_node current_user.name
        else
          text_node "Login with Discord"
        end

        if current_user&.avatar_url
          div class: "rounded-full overflow-hidden shadow-inner mb-1 mt-1 ml-2 grow-0 shrink-0 h-10 w-12" do
            helpers.image_tag current_user.avatar_url, class: "object-cover object-center"
          end
        else
          div class: "block grow-0 shrink-0 h-10 w-12 pl-5" do
            svg viewBox: "0 0 32 32", xmlns: "http://www.w3.org/2000/svg", aria_hidden: true, role: "presentation", focusable: false, style: "display: block; height: 100%; width: 100%; fill: currentcolor;" do
              tag :path, d: "m16 .7c-8.437 0-15.3 6.863-15.3 15.3s6.863 15.3 15.3 15.3 15.3-6.863 15.3-15.3-6.863-15.3-15.3-15.3zm0 28c-4.021 0-7.605-1.884-9.933-4.81a12.425 12.425 0 0 1 6.451-4.4 6.507 6.507 0 0 1 -3.018-5.49c0-3.584 2.916-6.5 6.5-6.5s6.5 2.916 6.5 6.5a6.513 6.513 0 0 1 -3.019 5.491 12.42 12.42 0 0 1 6.452 4.4c-2.328 2.925-5.912 4.809-9.933 4.809z"
            end
          end
        end
      end
    end
  end
end
