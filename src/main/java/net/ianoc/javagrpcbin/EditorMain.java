package net.ianoc.javagrpcbin;

import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Iterator;

class EditorMain {

  public static void main(String[] args) {
    try {
      Path workingPath = Paths.get(args[0]);

      List<String> lines = Files.readAllLines(workingPath, StandardCharsets.UTF_8);

      int idx = 0;
      int lastLoadStatement = -1;
      Iterator<String> iter = lines.iterator();
      while(iter.hasNext() && lastLoadStatement == -1) {
        String line = iter.next();
        if(line.startsWith("load(")) {
          lastLoadStatement = idx;
        }
        idx += 1;
      }
      if(lastLoadStatement == -1) {
        System.err.println("Unable to find any load statement");
        System.exit(-1);
      }

      lines.add(lastLoadStatement+1, "get_plugin_binares()");
      lines.add(lastLoadStatement+1, "load(\"//plugin_binaries:grpc_plugin.bzl\", \"get_plugin_binares\")");


      // Rename the cc binary

      idx = 0;
      int ccBinaryNameStatement = -1;
      iter = lines.iterator();
      while(iter.hasNext() && ccBinaryNameStatement == -1) {
        String line = iter.next();
        if(line.replace(" ", "").startsWith("name=\"grpc_java_plugin\"")) {
          ccBinaryNameStatement = idx;
        }
        idx += 1;
      }
      if(ccBinaryNameStatement == -1) {
        System.err.println("Unable to find grpc_java_plugi name line");
        System.exit(-1);
      }

      lines.set(ccBinaryNameStatement,  lines.get(ccBinaryNameStatement).replace("\"grpc_java_plugin\"", "\"grpc_java_plugin\""));

      Files.write(workingPath, lines, StandardCharsets.UTF_8);
    } catch(Exception e) {
      throw new RuntimeException(e);
    }
  }
}
