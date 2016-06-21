Sunny::Exchange.new :moment do
  only_if awaiting_moment: :set do
    store_moment

    only_if awaiting_moment: 1 do
      invoke_first :moment_1
    end

    only_if awaiting_moment: 2 do
      invoke_first :moment_2
    end

    only_if awaiting_moment: 3 do
      invoke_first :moment_3
    end
  end
end
