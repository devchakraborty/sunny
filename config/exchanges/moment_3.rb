Sunny::Exchange.new :moment_3 do
  only_if awaiting_moment: 3 do
    message do
      text 'Keep going! You\'re on a roll, I love hearing these. Any other stories?'
      text 'This is great! If you\'ve got any more, feel free to share!'
      text 'Cool! What else is new?'
      text 'Niiiiice. Anything else on your mind?'
      button :no, "Never mind."
    end
  end
end
