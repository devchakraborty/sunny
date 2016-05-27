Joy::Exchange.new :moment_3 do
  only_if awaiting_moment_3: true do
    message do
      text 'Keep going! You\'re on a roll, I love hearing these. Any other stories?'
      button :yes, "Yes"
      button :no, "No"
    end

    set_state :awaiting_yes_no_3
  end
end
