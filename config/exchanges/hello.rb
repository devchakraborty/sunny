Sunny::Exchange.new :hello do
  only_if opted_in: :unset do
    message do
      text "Hi #{first_name}, I'm Sunny!"
    end

    message do
      text "I'm stuck inside a computer, so unfortunately I don't get out much. Thankfully, I have you to tell me about the world!"
    end

    message do
      text "My friends say I'm a good listener, I love hearing about their days and reminding them about their brightest moments."
    end

    message do
      text "Let's start small: how's your week going? :)"
      button :no, "Never mind."
    end

    set_state :opted_in
    set_state :awaiting_moment, 1
  end

  only_if opted_in: true do
    message do
      text "Hi #{first_name}! How are things going?"
      text "Hey #{first_name}, what's up?"
      text "Yo #{first_name}, good to see you! Let's chat!"
      text "Hey there #{first_name}! What have you got to share?"
      text "What's up, #{first_name}? Let's talk!"
      button :no, "Never mind."
    end

    set_state :awaiting_moment, 1
  end
end
