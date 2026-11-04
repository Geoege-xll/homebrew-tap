class AwfCli < Formula
  desc "Terminal manager for Agent Workflow projects and role models"
  homepage "https://github.com/Geoege-xll/agent-workflow"
  url "https://github.com/Geoege-xll/agent-workflow/releases/download/v2.0.2/agent-workflow-2.0.2.tar.gz"
  version "2.0.2"
  sha256 "a9e4ac8c395d3c1b1bd66b0707828bba619ae93d5565d3b7cd48c9237965e41d"

  depends_on "python@3.14"

  def install
    libexec.install Dir["*"]
    bin.mkpath
    # Pin the default runtime without changing PATH; preserve explicit user selections.
    (bin/"awf-cli").write <<~SH
      #!/bin/bash
      export AGENT_WORKFLOW_PYTHON="${AGENT_WORKFLOW_PYTHON:-#{Formula["python@3.14"].opt_bin}/python3.14}"
      exec "#{libexec}/workflow.sh" "$@"
    SH
    (bin/"awf-cli").chmod 0755
  end

  test do
    assert_match "usage: awf-cli", shell_output("#{bin}/awf-cli --help")
    # 从已安装入口验证归档元数据与实际载荷根，避免仅凭 Formula 自身版本宣告成功。
    diagnostic = shell_output("#{bin}/awf-cli --version")
    assert_match "awf-cli #{version}", diagnostic
    assert_match "中央源根：#{libexec.realpath}", diagnostic
    assert_path_exists libexec/"lib/python_runtime.sh"
    assert_path_exists libexec/"setup_all.sh"
    assert_path_exists libexec/"platforms"
  end
end
