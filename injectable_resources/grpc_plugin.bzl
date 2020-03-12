def _grpc_plugin_impl(ctx):
    ctx.actions.run_shell(
            inputs = depset(transitive = [ctx.attr.binary_file.files]),
            outputs = [ctx.outputs.exe],
            command = "cp %s %s" % (ctx.attr.binary_file.files.to_list()[0].path, ctx.outputs.exe.path),
    )
    runfiles = ctx.runfiles(files = [ctx.outputs.exe])
    return [DefaultInfo(runfiles = runfiles, executable = ctx.outputs.exe)]

grpc_plugins = rule(
    implementation = _grpc_plugin_impl,
    attrs = {
        "binary_file": attr.label(
            mandatory=True,
            allow_single_file=True
        ),
    },
    executable = True,
    outputs = {"exe": "grpc_java_plugin"}
)



def get_plugin_binares():
  grpc_plugins(name = "grpc_java_plugin",
      binary_file = select(
     {

          "//plugin_binaries:osx_plat": "@io_grpc_grpc_java//plugin_binaries:protoc_grpc_java_plugin-macos",
          "//plugin_binaries:linux_plat": "@io_grpc_grpc_java//plugin_binaries:protoc_grpc_java_plugin-linux",
          "//conditions:default": ":protoc_cc",
      }),
  visibility=["//visibility:public"])
