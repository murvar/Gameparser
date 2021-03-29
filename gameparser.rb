load "./rdparse.rb"

class GameLanguage

  def initialize
    @gameParser = Parser.new("game language") do
      @user_assignments = {}
      token(/#.*/) #removes comment
      token(/\s+/) #removes whitespaces
      token(/^[-+]?\d+$/) {|m| m.to_i} #returns integers
      token(/\w+/) {|m| m } #returns chars
      token(/./) {|m| m } #returns rest

      start :prog do
        match(:comps) {|m| m }
      end

      rule :comps do
        match(:comps, :comp) {|m| m }
        match(:comp) {|m| m }
      end

      rule :comp do
        match(:type) {|m| m }
        match(:block_comp) {|m| m }
      end

      rule :block_comps do
        match(:block_comps, :block_comp)
        match(:block_comp)
      end

      rule :block_comp do
        match(:function) {|m| m }
        match(:cond_exp) {|m| m }
        match(:loop) {|m| m }
        match(:assignment) {|m| m }
        match("") # hur matchar vi Empty?
      end

      rule :function do
        match(:run)
        match(:read?)
        match(:write?)
      end

      rule :read do
      end

      rule :write do
      end

      rule :type do
        match(:event)
        match(:object)
      end

      rule :event do
        match("event", String, "{", :assignsments, :run,"}")
      end

      rule :assignsments do
        match(:assignsments, :assignment)
        match(:assignment)
      end

      rule :assignment do
        match(:var, "=", :value) { |m,  _, n| @user_assignments[m] = n}
      end

      rule :run do
        match("run", "(""example.rb", :block_comps, ")")
      end

      rule :var do
        match(String) {|s| s}
      end

      rule :values do
        match(:values, ",", :value) {|m, _, n| m + Array(n)}
        match(:value) {|m| Array(m)}
      end

      rule :value do
        match(:bool_val){|b| b}
        match('"', String, '"') {|_, s, _| s}
        match(Integer){|i| i}
        match(:array) {|a| a}
        match(:function_call) {|f| f}
        match(:var){|v| @user_assignments[v]}
      end

      rule :array do
        match("[", :values, "]") {|_, v, _| v}
        match("[", "]") {[]}
      end

      rule :object do
        match(:assignsments)
      end

      rule :loop do
        match(:while)
        match(:for)
      end

      rule :cond_exp do
        match(:if)
        match(:switch)
      end

      rule :while do
        match("while", :log_exp, "{", :block_comps, "}")
      end

      rule :if do
        match("if", :log_exp, "{", :block_comps, "}", "else", "{", :block_comps, "}")
        match("if", :log_exp, "{", :block_comps, "}")
      end

      rule :switch do
        match("case", :var, :cases)
      end

      rule :cases do
        match(:cases, :case)
        match(:case)
      end

      rule :case do
        match()
      end

      rule :for do
        match("for", :var, "in", :array, "{", :block_comps, "}")
      end

      rule :log_exp do
        match(:bool_exp, "and", :log_exp) {|m, _, n| m and n}
        match(:bool_exp, "or", :log_exp) {|m, _, n| m or n}
        match(:bool_exp) {|m| m}
      end

      rule :bool_exp do
        match(:math_exp, "<", :math_exp) {|m, _, n| m < n}
        match(:math_exp, "<=", :math_exp) {|m, _, n| m <= n}
        match(:math_exp, "==", :math_exp) {|m, _, n| m == n}
        match(:math_exp, ">", :math_exp) {|m, _, n| m > n}
        match(:math_exp, ">=", :math_exp) {|m, _, n| m >= n}
        match(:math_exp, "!=", :math_exp) {|m, _, n| m != n}
        match(:bool_val) {|m| m}
        match(:var) {|m| m}
      end

      rule :bool_val do
        match("True") {TRUE}
        match("False") {FALSE}
      end

      rule :math_exp do
        match(:math_exp, "+", :term) {|m, _, n| m + n}
        match(:math_exp, "-", :term) {|m, _, n| m - n}
        match(:term) {|m| m}
      end

      rule :term do
        match(:term, "*", :factor) {|m, _, n| m * n}
        match(:term, "/", :factor) {|m, _, n| m / n}
        match(:factor) {|m| m}
      end

      rule :factor do
        match(Integer) {|m| m}
        match(:var) {|m| m}
      end
    end

    def done(str)
      ["quit","exit","bye",""].include?(str.chomp)
    end

    def roll()
      print "[gameParser]"
      #str = File.read(file)
      str = gets
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@gameParser.parse str}"
        roll
      end
    end

    def log(state = true)
      if state
        @gameParser.logger.level = Logger::DEBUG
      else
        @gameParser.logger.level = Logger::WARN
      end
    end
  end
end

GameLanguage.new.roll()
