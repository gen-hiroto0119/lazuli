# Lazuli TODO List

## 優先度: 高 (Core Features)

- [ ] **CLIツールの実装 (`lazuli` コマンド)**
    - [ ] `lazuli new <project_name>`: 新規プロジェクトの作成
    - [ ] `lazuli server`: RubyサーバーとDenoサーバーを同時に起動するコマンド
    - [ ] `lazuli generate resource <name>`: Resource, Struct, Pageの雛形生成
- [ ] **ホットリロード (Hot Reload) の実装**
    - [ ] Rubyファイルの変更検知とサーバー再起動
    - [ ] TSXファイルの変更検知とブラウザリロード (Live Reload)
- [ ] **TypeScript型定義の自動生成**
    - [ ] `Lazuli::Struct` から `client.d.ts` を生成する機能
- [ ] **Turbo Drive の統合**
    - [ ] ページ遷移の高速化 (SPAライクな挙動)

## 優先度: 中 (Enhancements)

- [ ] **Islands Architecture の自動化**
    - [ ] `"use hydration"` ディレクティブの自動検出
    - [ ] Hydration用スクリプトの自動注入 (現在は手動で `script` タグを書いている)
- [ ] **エラーハンドリングの強化**
    - [ ] Deno側でのレンダリングエラーをRuby側で適切にキャッチして表示
    - [ ] 開発モードでの詳細なエラー画面
- [ ] **データベース連携の強化**
    - [ ] マイグレーション機能の統合
    - [ ] `Lazuli::Repository` のベースクラス実装

## 優先度: 低 (Future)

- [ ] **デプロイメントガイド**
    - [ ] Dockerfile の作成
    - [ ] VPS (Kamal等) へのデプロイ手順
- [ ] **テストフレームワークの統合**
    - [ ] Ruby側のRSpec統合
    - [ ] Deno側のテスト統合
- [ ] **ベンチマーク**
    - [ ] Rails, Hanami との比較

## 完了済み (Done)

- [x] **アーキテクチャの確立** (Ruby + Deno + Hono JSX)
- [x] **Zero Node Modules の実現** (esm.sh + Import Map)
- [x] **SSRの実装** (Hono JSX)
- [x] **クライアントサイドハイドレーションの実装** (Hono JSX DOM)
- [x] **Unix Domain Socket 通信の実装**
