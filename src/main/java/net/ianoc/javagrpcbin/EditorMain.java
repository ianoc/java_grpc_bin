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
      int licencesOffset = -1;
      Iterator<String> iter = lines.iterator();
      while(iter.hasNext() && licencesOffset == -1) {
        String line = iter.next();
        if(line.startsWith("licenses(")) {
          licencesOffset = idx;
        }
        idx += 1;
      }
      if(licencesOffset == -1) {
        System.err.println("Unable to find licence line");
        System.exit(-1);
      }

      lines.add(licencesOffset, "get_proto_binaries()");
      lines.add(licencesOffset, "load(\":protoc.bzl\", \"get_proto_binaries\")");


      // Rename the cc binary

      idx = 0;
      int ccBinaryNameStatement = -1;
      iter = lines.iterator();
      while(iter.hasNext() && ccBinaryNameStatement == -1) {
        String line = iter.next();
        if(line.replace(" ", "").startsWith("name=\"protoc\"")) {
          ccBinaryNameStatement = idx;
        }
        idx += 1;
      }
      if(ccBinaryNameStatement == -1) {
        System.err.println("Unable to find protoc name line");
        System.exit(-1);
      }

      lines.set(ccBinaryNameStatement,  lines.get(ccBinaryNameStatement).replace("\"protoc\"", "\"protoc_cc\""));

      Files.write(workingPath, lines, StandardCharsets.UTF_8);
    } catch(Exception e) {
      throw new RuntimeException(e);
    }
  }
}
