Joy::Exchange.new :yes_no_1 do
  only_if awaiting_yes_no_1: true do
    only_if just_expressed_yes_no: "yes" do
      message do
        text "Great! What was the best thing that happened to you this week?"
      end

      set_state :awaiting_moment
      set_state :awaiting_moment_1
    end

    only_if just_expressed_yes_no: "no" do
      message do
        text "Ahaha that's fine, I won't force you. :) But if you change your mind I'll be right here!"
      end
    end

    unset_state :awaiting_yes_no_1
  end
end
