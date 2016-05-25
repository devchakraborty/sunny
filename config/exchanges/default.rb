Joy::Exchange.new.setup :default do
  only_if_not :opted_in do
    message do
      text "Hi #{first_name}, I'm Joy! I'm stuck inside a computer, so unfortunately I don't get out much. Thankfully, I have you to tell me about the world!"
    end

    message do
      text "My friends say I'm a good listener, I love hearing about their days and reminding them about their brightest moments. Care to share?"
      button :yes, "Sure!"
      button :no, "No thanks."
    end

    add_state :opted_in
    add_state :awaiting_yes_or_no_entry
  end

  only_if :opted_in do
    message do
      text "Hi #{first_name}! How's your day coming along?"
    end
  end
end
