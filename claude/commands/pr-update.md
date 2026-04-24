# PR サマリ・チェックリスト更新

現在のブランチに紐づくPull Requestのサマリとテストプランを更新します。

## 手順

1. `gh pr list --head <current-branch>` で対象PRを特定
2. `gh pr view <number> --json title,body` で現在のPR内容を取得
3. `git log origin/main..HEAD --oneline` で全コミットを確認
4. `git diff origin/main..HEAD --stat` で変更ファイル一覧を確認
5. 現在のPR bodyの内容と実際のコミット内容を比較し、不足している項目を追加
6. テストプランのチェックボックスを実際の動作確認結果に基づいて更新
7. `gh pr edit` で更新を実行

## 更新方法

```bash
# PR bodyをファイルに書き出す
cat > /tmp/pr_body.md << 'HEREDOC'
## Summary
...
HEREDOC

# gh pr edit で更新
gh pr edit <number> --body-file /tmp/pr_body.md
```

## 使用コマンド・API

| コマンド | 用途 |
|---------|------|
| `gh pr list --head <branch> --json number,url` | 現在のブランチに紐づくPR番号を取得 |
| `gh pr view <number> --json title,body` | 現在のPRタイトル・本文を取得 |
| `git log origin/main..HEAD --oneline` | PRに含まれる全コミット一覧 |
| `git diff origin/main..HEAD --stat` | 変更ファイル統計 |
| `gh pr edit <number> --body-file <file>` | PR本文を更新 |

## フォールバック

`gh pr edit` が失敗する場合（Projects Classic エラー等）は REST API を使用:

```bash
gh api repos/{owner}/{repo}/pulls/{number} -X PATCH -F body=@/tmp/pr_body.md --jq '.html_url'
```

## 注意

- PRが存在しない場合はその旨を報告して終了
- 既存のSummary構造を尊重しつつ、新しいコミットの内容を追記する
- Test planのチェックボックスは、実際にテストを実行した結果のみチェック済みにする
