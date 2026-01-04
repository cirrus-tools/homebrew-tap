# typed: false
# frozen_string_literal: true

class ClaudeWarp < Formula
  desc "Fast model switching for Claude Code - switch when quota runs out"
  homepage "https://github.com/cirrus-tools/claude-warp"
  url "https://github.com/cirrus-tools/claude-warp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8529bfc53c36f434d7cf52a72e99b23ea67bd80f1cacd11e6b74daf3cc4263d8"
  license "MIT"
  version "0.1.0"
  head "https://github.com/cirrus-tools/claude-warp.git", branch: "main"

  depends_on "gum"
  depends_on "jq"
  depends_on "node"

  def install
    bin.install "bin/claude-warp"
  end

  def caveats
    <<~EOS
      To use with Antigravity proxy, install it first:
        npm install -g antigravity-claude-proxy

      Then add accounts:
        claude-warp acc add

      Usage:
        claude-warp s      Switch to Sonnet
        claude-warp o      Switch to Opus
        claude-warp n      Switch to Native API
        claude-warp start  Start proxy server
    EOS
  end

  test do
    assert_match "Claude Warp", shell_output("#{bin}/claude-warp help")
  end
end
