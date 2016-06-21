Sunny::Exchange.new :remind_me do
  only_if just_expressed_remind_me: :set do
    select_moment

    only_if found_moment: true do
      message do
        text "Hey #{first_name}, for sure! Remember this from #{moment_at}?:"
        text "Okay! How about this from #{moment_at}?:"
        text "Sure! Here's something from #{moment_at}:"
        text "No problem! This is from #{moment_at}:"
        text "Your wish is my command! Here's something from #{moment_at}:"
      end

      message do
        quoted_text moment_text
        moment_attachments true
      end
    end

    otherwise do
      message do
        text "Sorry #{first_name}, I couldn't find anything! Tell me more about what's going on and I'll do better next time."
      end
    end

    unset_state :just_expressed_remind_me
    unset_state :awaiting_yes_no
    unset_state :awaiting_moment
  end

  otherwise do
    invoke_first :default
  end
end
