# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 重要: 公開リポジトリについて

**このリポジトリは公開されています。** 変更・追加するすべてのファイルの内容を以下の観点で必ず精査してからコミットすること：

- APIキー・トークン・パスワード・秘密鍵などの認証情報を含めない
- 個人の環境に固有のパス（`/Users/miyazaki/...` など）をハードコードしない
- 社内サービスのURL・ホスト名・IPアドレスを含めない
- `settings.json` のパーミッション設定に内部ツール名や非公開サービスのMCPツール名を追加する場合は特に注意

## インストール

```bash
bash install.sh
```

`install.sh` は以下を行う：

1. `settings.json` を `~/.claude/settings.json` にコピー
2. `claude/commands/*.md` を `~/.claude/commands/` にコピー
3. `emit-turn-end.sh` を `~/.local/bin/` にインストールして実行権限を付与

## アーキテクチャ

### 設定ファイルの構成

```
claude/
  settings.json       # permissions (allow/deny/ask), effortLevel, hooks
```

### emit-turn-end.sh

tmux 環境下でのみ動作する Claude Code フック用スクリプト。`TMUX_PANE` 未設定時は即座に終了する。

- `stop` イベント: ペインボーダーに `✅ 完了` を表示
- `permission` イベント: ペインボーダーに `⏳ 確認待ち` を表示

### カスタムスラッシュコマンド (`claude/commands/`)

| コマンド | 内容 |
|---|---|
| `/commit-and-push` | ブランチ判定・ステージング・コミット・プッシュ |
| `/create-pr` | PRタイトル生成・`gh pr create` |
| `/pr-update` | PRサマリ・テストプランの更新 |
| `/pr-review-plan` | 未解決レビューコメントの取得と対応プランをMarkdown出力 |
| `/resolve-pr-comments` | 未解決コメントへのコード修正・返信・resolve |
| `/new-worktree` | `~/worktree/<repo>-<branch>` に worktree 作成 |
| `/clean-branches` | マージ済み・リモート追跡なしブランチの安全削除 |
| `/session-summary` | セッション作業まとめを `.claude/session-summary-*.md` に出力 |

コマンドファイルを編集する際は、`$ARGUMENTS` を利用して引数を受け取るパターンを維持すること。

## 設定を変更する際の注意

- `settings.json` の `permissions.deny` には main/master/develop への直接プッシュや `git add -A` などの危険操作が登録されている。これらは意図的な制約であり、削除しないこと
