# public-dotfiles

Claude Code 向けの dotfiles です。パーミッション設定・カスタムスラッシュコマンド・tmux 通知フックを管理しています。

## インストール

```bash
git clone <this-repo>
cd public-dotfiles
bash install.sh
```

以下がインストールされます：

- `claude/settings.json` → `~/.claude/settings.json`
- `claude/commands/*.md` → `~/.claude/commands/`
- `emit-turn-end.sh` → `~/.local/bin/emit-turn-end.sh`

## 内容

### `claude/settings.json`

Claude Code のグローバル設定。git・gh・docker などの許可コマンド、`git add -A` や main ブランチへの直接プッシュなどの禁止操作、および tmux 通知フックを定義しています。

### `emit-turn-end.sh`

tmux 使用時に Claude Code のターン終了・確認待ちをペインボーダーに表示するフック用スクリプト。tmux 外では何もしません。

### `claude/commands/`

カスタムスラッシュコマンド。`~/.claude/commands/` に配置することで `/commit-and-push` などの形式で呼び出せます。

| コマンド | 内容 |
|---|---|
| `/commit-and-push` | ブランチ判定・コミット・プッシュ |
| `/create-pr` | PR 作成 |
| `/pr-update` | PR サマリ・テストプランの更新 |
| `/pr-review-plan` | 未解決レビューコメントの対応プランを出力 |
| `/resolve-pr-comments` | レビューコメントへの修正・返信・resolve |
| `/new-worktree` | git worktree の作成 |
| `/clean-branches` | 不要ブランチの安全削除 |
| `/session-summary` | セッション作業まとめの出力 |