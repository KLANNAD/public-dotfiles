# Pull Request 作成

現在のブランチからPull Requestを作成します。

## 手順

1. `git status` で未コミットの変更がないか確認
2. `git branch` で現在のブランチを確認（main/masterでないことを確認）
3. `git log main..HEAD` または `git log origin/main..HEAD` でコミット履歴を確認
4. `git diff main...HEAD` でmainブランチとの差分を確認
5. 変更内容を分析し、PRのタイトルと説明を作成
6. `gh pr create` でPRを作成

## PRフォーマット

**`$(cat <<'EOF'...EOF)` 形式は使わない。** シングルクォートで `--body` に渡すこと：

```bash
gh pr create --title 'PRタイトル' --body '## Summary
- 変更内容1
- 変更内容2

## Test plan
- テスト計画

🤖 Generated with [Claude Code](https://claude.ai/code)'
```

bodyにシングルクォートが含まれる場合のみ、一時ファイルを使う：

```bash
printf '%s\n' '## Summary' '- 変更内容' '' '## Test plan' '- テスト計画' '' '🤖 Generated with [Claude Code](https://claude.ai/code)' > /tmp/pr_body.txt
gh pr create --title 'PRタイトル' --body-file /tmp/pr_body.txt
```

## 引数

- `$ARGUMENTS` が指定された場合はPRタイトルとして使用
- 指定がない場合はコミット内容から適切なタイトルを生成

## 注意

- main/master/developブランチからは実行しない
- リモートにプッシュされていない場合は先にプッシュする
- PR作成後、PRのURLを報告
