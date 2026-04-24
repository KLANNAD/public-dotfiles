# コミットしてプッシュ

変更をコミットしてリモートにプッシュします。

## 手順

1. `git branch` で現在のブランチを確認し、**ブランチ判定**を行う
   - 現在のブランチが `main`, `master`, `develop` のいずれかの場合 → **新しいブランチを作成してから進む**
     - $ARGUMENTS が指定された場合はブランチ名として使用
     - 指定がない場合は変更内容から適切なブランチ名を提案してユーザーに確認
     - ブランチ名の形式: `feature/xxx`, `fix/xxx`, `docs/xxx` など
   - それ以外のブランチの場合 → **そのまま現在のブランチで進む**
2. `git status` で変更ファイルを確認
3. `git diff` で変更内容を確認
4. 変更内容を分析し、適切なコミットメッセージを作成
5. 関連ファイルをステージング
6. コミットを実行
7. リモートにプッシュ（必ず `git push -u origin <branch-name>` でブランチ名を明示する。引数なしの `git push` は使わない）

## コミットメッセージ

- 変更の「なぜ」を重視した簡潔なメッセージ（1-2文）
- 末尾に `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>` を追加

## コミットコマンドの形式

**`$(cat <<'EOF'...EOF)` 形式は使わない。** シングルクォートで `-m` に渡すこと：

```bash
git commit -m 'メッセージ

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>'
```

メッセージ内にシングルクォートが含まれる場合のみ、一時ファイルを使う：

```bash
printf '%s\n' 'メッセージ' '' 'Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>' > /tmp/commit_msg.txt
git commit -F /tmp/commit_msg.txt
```

## 注意

- 機密情報を含むファイル（.env, credentials.json など）はコミットしない
- main/master/develop ブランチに直接プッシュしない
- プッシュ完了後、ブランチ名とリモートURLを報告
