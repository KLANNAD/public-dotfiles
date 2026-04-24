#!/bin/bash
# ============================================================
# emit-turn-end.sh — Claude Code ターン終了通知
#
# tmux ペインの TTY に BEL を送り、ペインボーダーに完了表示を出す。
# Claude Code の hooks (Stop / Notification) から呼ばれる想定。
#
# Usage: bash emit-turn-end.sh [event]
#   event: "stop" (デフォルト) / "permission"
# ============================================================

EVENT="${1:-stop}"

# tmux 内でなければ何もしない
[ -z "$TMUX_PANE" ] && exit 0

# ペインの TTY に直接 BEL を書き込む（tmux の monitor-bell を発火）
PANE_TTY="$(tmux display-message -p -t "${TMUX_PANE}" '#{pane_tty}')"
printf '\a' > "${PANE_TTY}"

# ペインボーダーにステータス表示（ユーザー変数）
if [ "$EVENT" = "permission" ]; then
  tmux set-option -pt "${TMUX_PANE}" @status "⏳ 確認待ち"
else
  tmux set-option -pt "${TMUX_PANE}" @status "✅ 完了"
fi
