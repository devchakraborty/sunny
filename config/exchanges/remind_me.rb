Sunny::Exchange.new :remind_me do
  only_if just_expressed_remind_me: :set do
    select_moment

    only_if found_moment: true do
      message do
        text "Hey #{first_name}, for sure! Remember this from #{moment_at}?:"
      end

      message do
        text "\"#{moment_text}\""
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
