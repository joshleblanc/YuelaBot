class SearchbarComponent < ApplicationComponent
 
  render do
    component_controller do
      form method: :get do
        div class: "flex space-x-2 m-4" do
          div class: "grow" do
            text_field_component :q, { value: params[:q], autofocus: true }
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