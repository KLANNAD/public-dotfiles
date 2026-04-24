# PRレビュープラン作成

PRの未解決コメントをすべて取得し、概要と修正プランをMarkdownファイルに出力します。

## 手順

1. 対象PRの特定
   - `$ARGUMENTS` が指定された場合はPR番号として使用
   - 指定がない場合は `gh pr view --json number` で現在のブランチのPRを取得

2. 未解決スレッドの取得（GraphQL API）

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      title
      url
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          comments(first: 10) {
            nodes {
              author { login }
              body
              createdAt
              url
            }
          }
        }
      }
    }
  }
}' \
-f owner="$(gh repo view --json owner -q .owner.login)" \
-f repo="$(gh repo view --json name -q .name)" \
-F pr=<PR番号>
```

3. `isResolved: false` かつ `isOutdated: false` のスレッドを抽出

4. コメントを分析し、以下のMarkdownファイルを生成：
   - ファイル名: `review-plan.md`（カレントディレクトリに出力）

## 出力フォーマット

```markdown
# レビュー対応プラン: <PRタイトル>

PR: <URL>
未解決コメント数: N件
作成日: <今日の日付>

---

## 概要

<未解決コメントの全体的な傾向・カテゴリを2〜3文で要約>

カテゴリ別内訳：
- バグ修正: N件
- コードスタイル: N件
- 設計・リファクタリング: N件
- その他: N件

---

## 修正プラン

### 1. <ファイルパス>:<行番号> — <コメントの1行要約>

**レビュアー**: @<author>
**コメント**:
> <コメント本文>

**対応方針**:
<具体的な修正内容を1〜3文で説明>

---

### 2. ...
```

## 注意

- `isOutdated: true` のスレッドは古いコード位置のため対応不要として除外
- スレッド内に複数コメントがある場合は最初のコメントを代表として使用
- 対応方針はコメント内容を読んで具体的に記述する（「修正する」だけにしない）
- 生成後、`review-plan.md` のパスをユーザーに報告
