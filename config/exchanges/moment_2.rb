Sunny::Exchange.new :moment_2 do
  only_if awaiting_moment: 2 do
    message do
      text 'That\'s awesome! Got any more stories?'
      text 'Nice! Anything else?'
      text 'Cool! More?'
      button :no, "Never mind."
    end

    set_state :awaiting_moment, 3
  end
end
