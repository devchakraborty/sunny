Joy::Exchange.new :moment_2 do
  only_if awaiting_moment_2: true do
    message do
      text 'That\'s awesome! Got any more stories?'
      button :yes, "Yes"
      button :no, "No"
    end

    unset_state :awaiting_moment_2
    set_state :awaiting_yes_no_3
  end
end
