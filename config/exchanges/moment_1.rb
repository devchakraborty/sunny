Sunny::Exchange.new :moment_1 do
  only_if awaiting_moment: 1 do
    message do
      text 'That sounds great! :) Anything else happen?'
      text 'Cool! Anything else?'
      text 'Awesome! Got more stories?'
      text 'That\'s dope! Any other news?'
      button :no, "Never mind."
    end

    set_state :awaiting_moment, 2
  end
end
