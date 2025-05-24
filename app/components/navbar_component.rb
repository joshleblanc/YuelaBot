# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  class NavbarLinkComponent < ApplicationComponent

    def initialize(navbar_link:)
      @label = navbar_link[:label]
      @to = navbar_link[:to].call
    end

    def active?
      request.path.split("/").second == @to.split("/").second
    end

    def base_classes
      "px-3 py-2 rounded-md text-sm font-medium"
    end

    def inactive_classes
      "text-primary-300 hover:bg-primary-700 hover:text-white"
    end

    def active_classes
      "bg-primary-900 text-white"
    end

    render do
      link_to @label, @to, class: class_names(base_classes, inactive_classes => !active?, active_classes => active?)
    end
  end

  def links
    @links = [
      { label: "Home", to: -> { root_path } },
    ]
    if current_user
      @links.push(
        { label: "Game Keys", to: -> { game_keys_path } },
        { label: "Reactions", to: -> { user_reactions_path }}
      )
    end
    @links
  end

  render do
    div class: "bg-primary-800" do
      div class: "mx-w-7xl mx-auto px-4 sm:px-6 lg:px-8" do
        div class: "flex items-center justify-between h-16" do
          div class: "flex items-center" do
            div class: "shrink-0" do
              h6 "Yuela", class: "text-white"
            end
          end
          div class: "flex items-center" do
            div class: "hidden md:block" do
              div class: "ml-10 flex items-baseline space-x-4" do
                navbar_link_collection links
              end
            end
          end
          div class: "hidden md:block" do
            div class: "ml-4 flex items-center md:ml-6" do
              button class: "bg-primary-800 p-1 rounded-full text-primary-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-primary-800 focus:ring-white" do
                span t(".view-notifications"), class: "sr-only"
                svg class: "h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", aria_hidden: "true" do
                  tag :path, stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                end
              end

              div class: "ml-3 relative" do
                profile_button
              end
            end
          end
          div class: "-mr-2 flex md:hidden" do
            button type: "button", class: "bg-primary-800 inline-flex items-center justify-center p-2 rounded-md text-primary-400 hover:text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-primary-800 focus:ring-white", aria_controls: "mobile-menu", aria_expanded: "false" do
              span t(".open-main-menu"), class: "sr-only"
            end

            svg class: "block h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", aria_hidden: "true" do
              tag :path, stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M4 6h16M4 12h16M4 18h16"
            end

            svg class: "hidden h-6 w-6", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", aria_hidden: "true" do
              tag :path, stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M6 18L18 6M6 6l12 12"
            end
          end
        end
      end
    end

  end
end
