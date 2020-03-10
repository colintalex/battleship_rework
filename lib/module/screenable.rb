module Screen
    def self.clear
        puts ""
        # print "\e[2J\e[f".  # For Terminal use
        print "\033[2J\033[H"  # For REPL use
    end
end
