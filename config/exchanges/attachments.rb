Sunny::Exchange.new :attachments do
  only_if awaiting_moment: :set do
    invoke_first :moment
  end

  otherwise do
    message do
      text "Sorry, I don't know what to do with that!"
    end
  end
end
