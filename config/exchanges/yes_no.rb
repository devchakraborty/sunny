Sunny::Exchange.new :yes_no do
  only_if awaiting_yes_no: :set do
    only_if just_expressed_yes_no: :unset do
      invoke_first :default
    end

    otherwise do
      only_if awaiting_yes_no: 1 do
        invoke_first :yes_no_1
      end

      only_if awaiting_yes_no: 2 do
        invoke_first :yes_no_2
      end

      only_if awaiting_yes_no: 3 do
        invoke_first :yes_no_3
      end

      unset_state :just_expressed_yes_no
      unset_state :awaiting_yes_no
    end
  end

  only_if awaiting_moment: :set do
    only_if just_expressed_yes_no: "no" do
      message do
        text "Oh okay, that's fine! You can tell me more later."
      end
    end

    otherwise do
      invoke_first :default
    end
  end

  otherwise do
    invoke_first :default
  end
end
