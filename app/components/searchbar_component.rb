class SearchbarComponent < ApplicationComponent
 
  render do
    component_controller do
      form "data-reflex" => "submit->Search#search" do
        div class: "flex space-x-2 m-4" do
          div class: "flex-grow" do
            text_field_component :q
          end
    
          div do
            button(class: ButtonComponent::CLASSNAMES, type: :submit) do 
              t(".search")
            end 
          end
        end
      end
    end
  end
end