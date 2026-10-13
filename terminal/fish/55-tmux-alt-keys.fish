if set -q TMUX
  for mode in insert default
    bind --preset -M $mode -e alt-left
    bind --preset -M $mode -e alt-right
    bind --preset -M $mode -e alt-up
    bind --preset -M $mode -e alt-down
    bind --preset -M $mode -e \e\[1\;9C
    bind --preset -M $mode -e \e\[1\;9D
    bind --preset -M $mode -e \e\[1\;9A
    bind --preset -M $mode -e \e\[1\;9B
  end
end
