Joy::Exchange.new :yes_no do
  only_if awaiting_yes_no: :set do
    only_if just_expressed_yes_no: :unset do
      message do
        text "Sorry, I didn't quite catch that. Is that a yes or a no?"
      end
    end

    otherwise do
      only_if awaiting_yes_no_1: true do
        invoke_first :yes_no_1
      end

      only_if awaiting_yes_no_2: true do
        invoke_first :yes_no_2
      end

      only_if awaiting_yes_no_3: true do
        invoke_first :yes_no_3
      end

      unset_state :just_expressed_yes_no
      unset_state :awaiting_yes_no
    end
  end

  otherwise do
    invoke_first :default
  end
end
