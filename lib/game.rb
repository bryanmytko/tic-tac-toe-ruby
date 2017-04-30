require_relative "player"
require_relative "build"
require "pry"

module Game
    class Manager
        include Helpers

        def initialize
            welcome_to_game
            make_players
            build_board
            @winner = nil
            @current_turn = randomize_starter
            play_game
        end

        private

        def randomize_starter
            [@player_one, @player_two].sample
        end

        def welcome_to_game
            puts "hi welcome to tic tac toe! \nhow big would you like your board to be?"
            @size = gets.chomp.to_i
            puts "size of board is #{@size}"
        end

        def make_players
            puts "what would you like to name the human?"
            @player_one = Player::Human.new(gets.chomp, "X")

            @player_two = Player::Computer.new("Computer", "O")
        end

        def build_board
            @board = Build::Board.new(@size)
        end

        def play_game
            while !@winner do
                @board.print_board
                @current_turn.play(@board)
                check_for_winner
                @current_turn = @current_turn == @player_one ? @player_two : @player_one
            end

            game_over
        end

        def options_left?
            choices = available_tiles(tiles)
            choices.length > 0 ? true : false
        end

        def check_for_winner
            check_horiztonal
            check_vertical
            check_diagonal
        end

        def check_horiztonal
            check_rows(@board)
        end

        def check_vertical
            rotate = @board.transpose
            check_rows(rotate)
        end

        def check_rows(board)
            board.each do |row|
                row_total = row.map{|tile| tile.value}.reduce(&:+)
                @winner = @player_one if row_total == @size
                @winner = @player_two if row_total == -@size
            end
        end

        def check_diagonal
            diagonals = (0..@board.length - 1).collect {|index| @board[index][index]}

            reverse_diagonals = (0..@board.length - 1).collect do |index|
                j = index == 0 ? -1 : (index * -1) - 1
                @board[index][j]
            end
            
            check_rows([diagonals, reverse_diagonals])
        end

        def game_over
            puts "game over #{@winner.name} won!"
            @board.print_board
        end
    end
end

Game::Manager.new()
