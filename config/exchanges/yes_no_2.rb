Sunny::Exchange.new :yes_no_2 do
  only_if awaiting_yes_no: 2 do
    only_if just_expressed_yes_no: "yes" do
      message do
        text "Sweet! I'm all ears... Or eyes :S ahaha!"
      end

      set_state :awaiting_moment, 2
    end

    only_if just_expressed_yes_no: "no" do
      message do
        text "Ok no worries, I'll definitely remember that one though!"
      end
    end
  end
end
