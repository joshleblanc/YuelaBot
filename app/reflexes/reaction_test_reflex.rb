class ReactionTestReflex < ApplicationReflex
  def run(args)
    match = Regexp.new(args["regex"]).match(args["input"])
    result = if match
      args["input"].sub(/#{args["regex"]}/, args["output"])
    else
      ""
    end

    morph("#test-result", render(partial: "user_reactions/test_result", locals: { output: result, match: match }))
  end
end
