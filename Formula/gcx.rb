# typed: false
# frozen_string_literal: true

class Gcx < Formula
  desc "GCloud Context Switcher - Quick switch for GCP orgs, accounts, projects"
  homepage "https://github.com/cirrus-tools/gcx"
  url "https://github.com/cirrus-tools/gcx/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "4b16506029d8a6ee116da53c13c2552100b9ea13ede5235f421dd4c2e8e88c54"
  license "MIT"
  version "1.2.4"
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
