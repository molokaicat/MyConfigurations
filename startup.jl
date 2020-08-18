using Pkg
using Revise
using REPL
using Highlights
import REPL.LineEdit



println("... execution of ", @__FILE__)

# Change prompt colors, since default ones are hard to see on white background
function customize_colors(repl)
   # Customize colors:
   #   https://docs.julialang.org/en/latest/stdlib/REPL/
   #
   # Available colors:
   #   ?Base.text_colors
   #      :normal, :default, :bold, :black, :blink, :blue, :cyan, :green, :hidden,
   #      :light_black, :light_blue, :light_cyan, :light_green, :light_magenta,
   #      :light_red, :light_yellow, :magenta, :nothing, :red, :reverse, :underline,
   #      :white, or :yellow as well as the integers 0 to 255 inclusive.
   #
   #
   repl.prompt_color = Base.text_colors[:blue]
   repl.help_color   = Base.text_colors[:magenta]
   repl.shell_color  = Base.text_colors[:magenta]
   repl.input_color  = Base.text_colors[:magenta]
   repl.answer_color = Base.text_colors[:magenta]
end

Base.atreplinit(customize_colors)

ENV["JULIA_WARN_COLOR"] = :light_red
ENV["JULIA_INFO_COLOR"] = :magenta

# to get a custom R to work with RCall
# https://groups.google.com/forum/#!topic/epacts/5JNFkpmyuSU
# fix the libR.so problem
ENV["R_HOME"] = "/opt/R/4.0.0/lib/R"
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/methods/libs" =#
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/utils/libs" =#
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/grDevices/libs" =#
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/graphics/libs" =#
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/stats/libs" =#
#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/library/" =#

#= ENV["R_LIBS"] = "/opt/R/4.0.0/lib/R/lib" =#
ENV["JULIA_NUM_THREADS"] = 4
ENV["EDITOR"] = "vim"
ENV["PYTHON"] = "/usr/bin/python3"


#REPL formatting Environment variables that determine how REPL output should be
#formatted at the terminal. Generally, these variables should be set to ANSI
#terminal escape sequences. Julia provides a high-level interface with much of
#the same functionality; see the section on The Julia REPL.
#
#JULIA_ERROR_COLOR The formatting Base.error_color() (default: light red,
#"\033[91m") that errors should have at the terminal.
#ENV["JULIA_ERROR_COLOR"] = :"\033[95m"
#
#JULIA_WARN_COLOR The formatting Base.warn_color() (default: yellow,
#"\033[93m") that warnings should have at the terminal.
#ENV["JULIA_WARN_COLOR"] = "\033[93m"
#
#JULIA_INFO_COLOR The formatting Base.info_color() (default: cyan, "\033[36m")
#that info should have at the terminal.
#ENV["JULIA_INFO_COLOR"] = "\033[36m"
#
#JULIA_INPUT_COLOR The formatting Base.input_color() (default: normal,
#"\033[0m") that input should have at the terminal.
#ENV["JULIA_INPUT_COLOR"] = :"\033[95m"
#
#JULIA_ANSWER_COLOR The formatting Base.answer_color() (default: normal,
#"\033[0m") that output should have at the terminal.
#ENV["JULIA_ANSWER_COLOR"] = "\033[95m"
#
#JULIA_STACKFRAME_LINEINFO_COLOR The formatting
#Base.stackframe_lineinfo_color() (default: bold, "\033[1m") that line info
#should have during a stack trace at the terminal.
#ENV["JULIA_STACKFRAME_LINEINFO_COLOR"] =
#
#JULIA_STACKFRAME_FUNCTION_COLOR The formatting
#Base.stackframe_function_color() (default: bold, "\033[1m") that function
#calls should have during a stack trace at the terminal.
#ENV["JUlia_stackframe_function_color"] =


println("Setup successful")


const mykeys = Dict{Any,Any}(
    # Up Arrow
    "\e[A" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_prev(s, LineEdit.mode(s).hist)),
    # Down Arrow
    "\e[B" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_next(s, LineEdit.mode(s).hist)),
#    # Move cursor left
#    "\eh" => (s,o...) -> (LineEdit.edit_move_left(s)),
#    #
    "^D" => (s,o...)->(LineEdit.move_line_start(s); LineEdit.refresh_line(s)),
    "^E" => (s,o...)->(LineEdit.move_line_end(s); LineEdit.refresh_line(s)),
#    #(LineEdit.deactivate(s))
#
#
#    # TODO fix
#    #"^d^d" => (s,o...) -> (LineEdit.edit_clear(s)),
#    "^U" => (s,o...) -> (LineEdit.edit_undo!(s)),
#    "^R" => (s,o...) -> (LineEdit.edit_redo!(s)),
#    #"\$" => (s,o...) -> (println("dollar sign works \$\$\$\$")), #Works

    "\e\b"    => (s,data,c)->(isempty(edit_delete_prev_word(data.query_buffer)) ?
                                  beep(s) : update_display_buffer(s, data)),
)

function customize_keys(repl)
    repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

atreplinit(customize_keys)

