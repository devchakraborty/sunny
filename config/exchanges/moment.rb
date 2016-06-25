Sunny::Exchange.new :moment do
  only_if awaiting_moment: :set do
    store_moment
    process_sentiment

    only_if last_user_message_sentiment_category: :positive do
      message do
        text 'That sounds great! :) Anything else happen?'
        text 'Cool! Anything else?'
        text 'Awesome! Got more stories?'
        text 'That\'s dope! Any other news?'
        text 'That\'s awesome! Got any more stories? I\'m here to listen.'
        text 'Nice! Anything else? I\'m all ears.'
        text 'Cool! Got more to share? Hit me!'
        text 'Keep going! You\'re on a roll, I love hearing these. Any other stories?'
        text 'This is great! If you\'ve got any more, feel free to share!'
        text 'Cool! What else is new?'
        text 'Niiiiice. Anything else on your mind?'
        button :no, 'Never mind.'
      end
    end

    only_if last_user_message_sentiment_category: :negative do
      message do
        text 'Sorry to hear that. Do you have more to share?'
        text 'That sucks, I\'m sorry about that. Got anything brighter to share, though? :)'
        text 'Damn, that\'s tough. What else is on your mind?'
        text 'Damn. Got any more stories? I\'m here to listen.'
        text 'Aw. Anything else? I\'m all ears.'
        text 'Yikes. Got more to share? Hit me!'
        button :no, 'Never mind.'
      end
    end

    otherwise do # neutral
      message do
        text 'Interesting, thanks for sharing! :) Anything else happen?'
        text 'Okay, that\'s cool. What else happened for you?'
        text 'Cool. Got more stories?'
        text 'Nice. Any other news?'
        button :no, 'Never mind.'
      end
    end
  end
end
