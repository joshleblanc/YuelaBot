class CannedResponseGenerator

  def generate(name)
    responses.sample.gsub("<>", name)
  end

  private
  def responses
    [
      "Stack Overflow and <> have come to an agreement. We believe that <> was not acting with malicious intent. We believe <> did not understand all of the nuances and full intent and meaning of our Code of Conduct and was confused about what actions it required and forbade.",
      "We acknowledge our responses to <>'s requests for clarification were not satisfactory. The verbiage in our Code of Conduct could have been more explicitly detailed about what was expected. We always valued <>’s contributions to the community and respect <>'s intelligence, integrity, and professional writing skills.",
      "While our initial statement did not address <> specifically, we regret that we used <>'s name when responding to a reporter's follow-up. We regret any damage to <>'s reputation and any other damage <> may have suffered.",
      "We have since updated some of our policies and processes to help ensure we are more careful in our public communications, and that there is a clearer process anytime a moderator's status is revoked as well as a process for reinstatement.",
      "You all should know this is very hard for us.",
      "Please expedite the deleting of this account. I have dithered for some time about the value of keeping this account and on the balance I do not like the community or the experience",
      "I strongly endorse and appreciate all the changes you are making and wish the staff the very best through all this.",
      "Don't ping random people like that. You've been told that before in the JavaScript room.",
      "<> I'm sorry you have felt attacked by me. I won't mention those things again. I sincerely hope you get this resolved one way or another. Take care. It must be a hard time.",
      "Stop following me",
      "Stop bulling me"
    ]
  end
end
