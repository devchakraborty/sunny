Joy::Exchange.new :remind_me do
  only_if awaiting_yes_no: :set do
    invoke_first :yes_no
  end

  only_if awaiting_moment: :set do
    invoke_first :default
  end

  only_if just_expressed_remind_me: :set do
    select_moment

    only_if found_moment: true do
      message do
        text "Hey #{first_name}, for sure! Remember when this happened?:"
      end

      message do
        text "\"#{moment_text}\"\n\n(#{moment_at})"
      end
    end

    otherwise do
      message do
        text "Sorry #{first_name}, I couldn't find anything! Tell me more about what's going on and I'll do better next time."
      end
    end

    unset_state :just_expressed_remind_me
  end

  otherwise do
    invoke_first :default
  end
end
