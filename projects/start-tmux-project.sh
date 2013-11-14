if [ ! -z $1 ]
then
    PROJ_NAME=${1}
else
    PROJ_NAME="untitled_project"
fi

if tmux has-session -t "$PROJ_NAME"; then
    echo "Attaching to session $PROJ_NAME"
    tmux attach-session -t "$PROJ_NAME"
else
    echo "Creating session $PROJ_NAME"
    tmux new-session -d -s "$PROJ_NAME"
    tmux rename-window  -t $PROJ_NAME:1 "Editor"
    tmux new-window -t $PROJ_NAME:2 -n "Development"
    tmux split-window -h -t $PROJ_NAME:2

    tmux send-keys -t $PROJ_NAME:1 "vim -c ':NERDTreeToggle'" C-m

    tmux select-window -t $PROJ_NAME:1
    tmux -2 attach-session -t $PROJ_NAME
fi
