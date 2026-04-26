#!/usr/bin/env bash

_help_desc "conan" "开发" "Conan C/C++ 包管理速查"

help-conan() {
  cat <<'EOF'
── Conan 1（必要功能分类）────────────────────────────────────
  [1) 环境确认]
    conan --version
    conan profile list
    conan profile show <your_profile>

  [2) 打包导出]
    conan export-pkg -f -pf <package_folder> conanfile.py <user>/<channel> \
      -pr <your_profile> -s build_type=<Release|Debug> \
      -o <name>:<option1>=<value1> -o <name>:<option2>=<value2>

  [3) 导出校验]
    conan search <name>/<version>@<user>/<channel>
    conan search <name>/<version>@<user>/<channel> --revisions
    conan inspect <name>/<version>@<user>/<channel> -a options

  [4) 发布上传]
    conan upload <name>/<version>@<user>/<channel> --all -r <remote>

  [5) 消费安装]
    conan remove <name>/<version>@<user>/<channel> -f
    conan install . -pr <your_profile> -s build_type=<Release|Debug> \
      -o <name>:<option1>=<value1> \
      -o <name>:<option2>=<value2> \
      --update

  [6) conan install 常用功能]
    # 基础安装（缺什么补什么）
      conan install . --build=missing
    # 指定 profile / build_type
      conan install . -pr <your_profile> -s build_type=Debug
    # 指定 options
      conan install . -o <name>:<option>=<value>
    # 强制从远端更新
      conan install . --update

  [示例（safety-function）]
    conan export-pkg -f -pf output/safety-function conanfile.py guard/stable \
      -pr aarch64_gcc12.2 -s build_type=Release \
      -o enable_hsd=False -o enable_flat_proto_msg=True
    conan search safety-function/0.0.0@guard/stable --revisions
    conan upload safety-function/0.0.0@guard/stable --all -r conan-test
    conan remove safety-function/0.0.0@guard/stable -f
    conan install . -pr aarch64_gcc12.2 -s build_type=Release \
      -o safety-function:enable_hsd=False \
      -o safety-function:enable_flat_proto_msg=True \
      --update
─────────────────────────────────────────────────────────────
EOF
}
