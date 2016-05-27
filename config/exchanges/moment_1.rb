Joy::Exchange.new :moment_1 do
  only_if awaiting_moment_1: true do
    message do
      text 'That sounds great! :) Anything else happen?'
      button :yes, "Yes"
      button :no, "No"
    end

    unset_state :awaiting_moment_1
    set_state :awaiting_yes_no_2
  end
end
