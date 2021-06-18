class SubNavComponent < ApplicationComponent
  class LinkComponent < ApplicationComponent
    def initialize(link:)
      @to = link[:to].call
      @label = link[:label]
    end

    def active_classes
      "font-medium text-gray-800 dark:text-gray-200 bg-gray-100 dark:bg-gray-800"
    end

    def inactive_classes
      "text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800"
    end

    def default_classes
      "px-3 py-1.5 rounded-lg capitalize"
    end

    def classes
      class_names default_classes, inactive_classes => inactive?, active_classes => active? 
    end

    def active?
      request.path.chomp("/") == @to.chomp("/")
    end

    def inactive?
      !active?
    end

    render do
      link_to @label, @to, class: classes
    end
  end

  render do
    div class: "flex items-center mt-3 mb-3 space-x-4 overflow-y-auto 2xl:justify-center whitespace-nowrap" do
      text_node helpers.send(:content)
    end
  end
end