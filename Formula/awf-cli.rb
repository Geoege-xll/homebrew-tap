class AwfCli < Formula
  desc "Terminal manager for Agent Workflow projects and role models"
  homepage "https://github.com/Geoege-xll/agent-workflow"
  url "https://github.com/Geoege-xll/agent-workflow/releases/download/v0.1.0/agent-workflow-0.1.0.tar.gz"
  version "0.1.0"
  sha256 "2f6966db026130b332f9fe9bbd67669a534f16b05ac2eaf3cc2d0470f8532434"

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
    assert_path_exists libexec/"lib/python_runtime.sh"
    assert_path_exists libexec/"setup_all.sh"
    assert_path_exists libexec/"platforms"
  end
end
