Joy::Exchange.new :moment_2 do
  only_if awaiting_moment: 2 do
    message do
      text 'That\'s awesome! Got any more stories?'
      button :yes, "Yes"
      button :no, "No"
    end

    unset_state :awaiting_moment
    set_state :awaiting_yes_no, 3
  end
end
