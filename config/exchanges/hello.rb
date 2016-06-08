Sunny::Exchange.new :hello do
  only_if opted_in: :unset do
    message do
      text "Hi #{first_name}, I'm Sunny! I'm stuck inside a computer, so unfortunately I don't get out much. Thankfully, I have you to tell me about the world!"
    end

    message do
      text "My friends say I'm a good listener, I love hearing about their days and reminding them about their brightest moments. Care to share?"
      button :yes, "Sure!"
      button :no, "No thanks."
    end

    set_state :opted_in
    set_state :num_moments, 0
    set_state :awaiting_yes_no, 1
  end

  only_if opted_in: true do
    message do
      text "Hi #{first_name}! How are things going? Wanna share?"
      button :yes, "Sure!"
      button :no, "No thanks."
    end

    set_state :awaiting_yes_no, 1
  end
end
