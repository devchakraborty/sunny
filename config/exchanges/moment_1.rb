Joy::Exchange.new :moment_1 do
  only_if awaiting_moment: 1 do
    message do
      text 'That sounds great! :) Anything else happen?'
      button :yes, "Yes"
      button :no, "No"
    end

    set_state :awaiting_yes_no, 2
  end
end
