# PR未解決コメントの修正・resolve

PRの未解決コメントを取得し、対応するコード修正を行い、修正概要をコメントしてresolveする。

## 手順

1. 対象PRの特定
   - `$ARGUMENTS` が指定された場合はPR番号として使用
   - 指定がない場合は `gh pr view --json number -q .number` で現在のブランチのPRを取得

2. 未解決スレッドの取得（GraphQL API）

```bash
gh api graphql -f query='
query {
  repository(owner: "<owner>", name: "<repo>") {
    pullRequest(number: <PR番号>) {
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
}'
```

- `owner` と `repo` は `gh repo view --json owner,name` で取得
- `isResolved: false` のスレッドのみ対象
- `isOutdated: true` のスレッドは修正済みコードに対するものなので **修正不要だがresolveは行う**

3. 未解決コメントの分類

各コメントを以下に分類する：
- **要修正**: コードの変更が必要なもの（バグ、設計指摘、スタイル修正など）
- **outdated**: `isOutdated: true` で、既にコードが変更されているもの
- **対応不要**: 質問への回答やFYIなど、コード修正が不要なもの

4. コード修正の実施

「要修正」に分類されたコメントについて：
- コメントで指摘されたファイル・行を読み、指摘内容を理解する
- 適切な修正を実施する

5. 修正のコミット＆プッシュ

「要修正」の修正が1件以上あった場合、コミットしてプッシュする：

```bash
git add <修正ファイル>
git commit -m "レビュー指摘対応: <修正内容の概要>"
git push
```

- `git add -A` や `git add .` は使わず、修正したファイルのみ個別に指定する
- 修正が0件（outdatedと対応不要のみ）の場合はコミット不要

6. 各スレッドにコメント + resolve

すべての未解決スレッド（修正したもの・outdated・対応不要すべて）に対して：

### 返信コメントの投稿

```bash
gh api graphql -f query='
mutation {
  addPullRequestReviewThreadReply(input: {
    pullRequestReviewThreadId: "<threadId>",
    body: "<修正概要>"
  }) {
    comment { id }
  }
}'
```

### スレッドのresolve

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {
    threadId: "<threadId>"
  }) {
    thread { isResolved }
  }
}'
```

7. 結果の報告

最後に以下を報告する：
- 修正したファイル一覧と変更概要
- resolveしたスレッド数
- 修正が必要だったが対応できなかったもの（あれば）

## 返信コメントの書き方

- **要修正（修正済み）**: `修正しました。<具体的に何をしたか1文>`
- **outdated**: `コード変更により outdated になっています。修正済みです。`（実際に修正が反映されている場合）
- **対応不要**: 適切な返答（質問への回答など）

## 注意

- コミット・プッシュ後にコメントとresolveを行う（pushが先）
- GraphQL の query 内にシングルクォートを含めないこと（bash のクォーティングと衝突する）
- 1つのスレッドに複数コメントがある場合は、スレッド全体の文脈を読んで対応方針を決める
- レビュアーの意図が不明な場合は、修正せずユーザーに確認を求める
