# typed: false
# frozen_string_literal: true

class Gcx < Formula
  desc "GCloud Context Switcher - Quick switch for GCP orgs, accounts, projects"
  homepage "https://github.com/cirrus-tools/gcx"
  url "https://github.com/cirrus-tools/gcx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e7a61b8e86ef2c06901fe8953f6a3f1e1f0fd5f5d45ab4d12e07f21fc3455121"
  license "MIT"
  version "1.3.0"
  head "https://github.com/cirrus-tools/gcx.git", branch: "main"

  depends_on "yq"
  depends_on "gum"

  def install
    bin.install "bin/gcx.sh" => "gcx"
    (lib/"gcx").install "lib/gcx-setup.sh"
    (lib/"gcx").install "lib/gcx-adc.sh"
    (lib/"gcx").install "lib/gcx-vm.sh"
    (lib/"gcx").install "lib/gcx-run.sh"
    bash_completion.install "completions/gcx.bash" => "gcx"
    zsh_completion.install "completions/_gcx"
  end

  def caveats
    <<~EOS
      To get started, run:
        gcx setup

      Dependencies (install separately if needed):
        brew install --cask google-cloud-sdk
        brew install kubectl
    EOS
  end

  test do
    assert_match "gcx", shell_output("#{bin}/gcx --help")
  end
end
