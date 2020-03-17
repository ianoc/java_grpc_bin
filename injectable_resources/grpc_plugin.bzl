def _grpc_plugin_impl(ctx):
    f = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
            inputs = depset(transitive = [ctx.attr.binary_file.files]),
            outputs = [f],
            command = "cp %s %s" % (ctx.attr.binary_file.files.to_list()[0].path, f.path),
    )
    runfiles = ctx.runfiles(files = [f])
    return [DefaultInfo(runfiles = runfiles, executable = f)]

grpc_plugins = rule(
    implementation = _grpc_plugin_impl,
    attrs = {
        "binary_file": attr.label(
            mandatory=True,
            allow_single_file=True
        ),
    },
    executable = True,
)



def get_plugin_binares():
  grpc_plugins(name = "grpc_java_plugin",
      binary_file = select(
     {

          "//plugin_binaries:osx_plat": "@io_grpc_grpc_java//plugin_binaries:protoc_grpc_java_plugin-macos",
          "//plugin_binaries:linux_plat": "@io_grpc_grpc_java//plugin_binaries:protoc_grpc_java_plugin-linux",
          "//conditions:default": ":grpc_java_plugin_cc",
      }),
  visibility=["//visibility:public"])
