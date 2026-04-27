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

  [3) 导出校验 / 远端查询]
    # 查本地缓存
    conan search <name>/<version>@<user>/<channel>
    conan search <name>/<version>@<user>/<channel> --revisions
    # 查看包声明了哪些 options
    conan inspect <name>/<version>@<user>/<channel> -a options
    # 查远端所有预编译包（含 options/settings/requires）
    conan search <name>/<version>@<user>/<channel> -r <remote>
    # 只看关键字段摘要
    conan search <name>/<version>@<user>/<channel> -r <remote> \
      | grep -E '(Package_ID|arch:|build_type:|enable_)'
    # 生成 HTML 表格
    conan search <name>/<version>@<user>/<channel> -r <remote> --table=table.html
    # 查远端 revisions
    conan search <name>/<version>@<user>/<channel> -r <remote> --revisions

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
    # ── 打包导出 ──
    conan export-pkg -f -pf output/safety-function conanfile.py guard/stable \
      -pr aarch64_gcc12.2 -s build_type=Release \
      -o enable_hsd=False -o enable_flat_proto_msg=True

    # ── 查远端有哪些预编译包 ──
    #   场景：conan install 报 "Missing prebuilt package"，想看远端到底有哪些组合
    conan search safety-function/100.0.23@guard/stable -r conan-test
    #   只看摘要（推荐）：
    conan search safety-function/100.0.23@guard/stable -r conan-test \
      | grep -E '(Package_ID|arch:|build_type:|enable_)'
    #   → 对比自己需要的 arch + build_type + options 组合，缺了就要自己编译上传

    # ── 上传 / 删除 / 安装 ──
    conan upload safety-function/0.2.01@guard/stable --all -r conan-test
    conan remove safety-function/0.2.01@guard/stable -f
    conan install . -pr aarch64_gcc12.2 -s build_type=Release \
      -o safety-function:enable_hsd=False \
      -o safety-function:enable_flat_proto_msg=True \
      --update
─────────────────────────────────────────────────────────────
EOF
}
