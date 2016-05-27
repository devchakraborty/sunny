Joy::Exchange.new :hello do
  only_if opted_in: :unset do
    message do
      text "Hi #{first_name}, I'm Joy! I'm stuck inside a computer, so unfortunately I don't get out much. Thankfully, I have you to tell me about the world!"
    end

    message do
      text "My friends say I'm a good listener, I love hearing about their days and reminding them about their brightest moments. Care to share?"
      button :yes, "Sure!"
      button :no, "No thanks."
    end

    set_state :opted_in
    set_state :num_moments, 0
    set_state :awaiting_yes_no
    set_state :awaiting_yes_no_1
  end

  only_if opted_in: true do
    message do
      text "Hi #{first_name}! How's your day coming along?"
    end

    set_state :awaiting_moment
    set_state :awaiting_moment_1
  end
end
