Sunny::Exchange.new :help do
  only_if just_expressed_help: :set do
    message do
      text "Sure! You can say hi to me anytime to start a conversation. After we chat, I'll write down how your day went so I can remind you about it later. :)"
    end

    message do
      text "You can also say something like the following if you'd like to remember what you've told me:\n\n- Remember a random moment\n- Remember last week\n- Remember yesterday\n"
    end

    message do
      text "You can say \"help\" to show this message again. I hope that was helpful! :)"
    end

    unset_state :just_expressed_help
    unset_state :awaiting_yes_no
    unset_state :awaiting_moment
  end

  otherwise do
    invoke_first :default
  end
end
