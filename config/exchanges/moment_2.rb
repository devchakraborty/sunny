Sunny::Exchange.new :moment_2 do
  only_if awaiting_moment: 2 do
    message do
      text 'That\'s awesome! Got any more stories? I\'m here to listen.'
      text 'Nice! Anything else? I\'m all ears.'
      text 'Cool! Got more to share? Hit me!'
      button :no, "Never mind."
    end

    set_state :awaiting_moment, 3
  end
end
