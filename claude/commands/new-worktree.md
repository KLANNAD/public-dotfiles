# Worktree 作成

現在のリポジトリから新しい git worktree を作成します。

## 手順

1. `git branch` で現在のブランチを確認
2. $ARGUMENTS が指定された場合はブランチ名として使用、なければユーザーに確認
3. worktree を作成
   ```
   git worktree add -b <branch-name> ${HOME}/worktree/<repo-name>-<branch-name>
   ```
4. 作成したworktreeのパスを報告

## ディレクトリ規則

- 作成先: `${HOME}/worktree/<repo-name>-<branch-name>`
- 例: リポジトリが `dotfiles`、ブランチが `feature/add-login` の場合
  → `${HOME}/worktree/dotfiles-feature-add-login`（スラッシュはハイフンに変換）

## 注意

- 既に同名のworktreeが存在する場合はユーザーに確認
- ブランチ名の形式: `feature/xxx`, `fix/xxx`, `docs/xxx` など
