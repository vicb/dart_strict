// Copyright (c) 2014, Paul Jolly

// This code borrows heavily from an example provided in the Dart source:
// https://github.com/dart-lang/bleeding_edge/blob/0000fe553ef26b2f8749dd390cd7b8c4e5e488df/dart/pkg/analyzer/example/resolver_driver.dart
// With due reference therefore to the copyright notice on that code

import 'package:analyzer/src/generated/java_io.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/sdk.dart' show DartSdk;
import 'package:analyzer/src/generated/sdk_io.dart' show DirectoryBasedDartSdk;
import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/engine.dart';

import 'dart:io';

main(List<String> args) {

  if (args.length != 2) {
    print('Usage: dart_strict [path_to_sdk] [file_to_analyze]');
    exit(0);
  }

  JavaSystemIO.setProperty("com.google.dart.sdk", args[0]);
  DartSdk sdk = DirectoryBasedDartSdk.defaultSdk;

  AnalysisContext context = AnalysisEngine.instance.createAnalysisContext();
  context.sourceFactory = new SourceFactory([new DartUriResolver(sdk), new FileUriResolver()]);
  Source source = new FileBasedSource.con1(new JavaFile(args[1]));
  
  LineInfo li = context.computeLineInfo(source);
  
  ChangeSet changeSet = new ChangeSet();
  changeSet.addedSource(source);
  context.applyChanges(changeSet);
  LibraryElement libElement = context.computeLibraryElement(source);
  
  CompilationUnit resolvedUnit = context.resolveCompilationUnit(source, libElement);
  var visitor = new _ASTVisitor(li);
  resolvedUnit.accept(visitor);
  
  if (visitor.found_errors) {
    exit(1);
  }
}

class _ASTVisitor extends GeneralizingAstVisitor {
  bool found_errors = false;
  LineInfo line_info;
  
  _ASTVisitor(LineInfo this.line_info);
  
  void printHint(String msg, int offset) {
    LineInfo_Location lo = line_info.getLocation(offset);  
    print("[${lo.lineNumber}:${lo.columnNumber}] $msg");
  }
  
  void visitNode(AstNode node) {
    String text = '${node.runtimeType} : <"${node.toString()}">';
    if (node is FunctionDeclaration) {
      if (node.returnType == null) {
        found_errors = true;
        printHint("Missing a return type for function '${node.name}'", node.beginToken.offset);
      }
    } else if (node is VariableDeclaration) {
      // can this ever be the case?
      if (node.element.type == null) {
        found_errors = true;
        printHint("Variable '${node.name}' is missing a type annotation", node.beginToken.offset);
      } else if (node.element.type.isDynamic) {
        found_errors = true;
        printHint("Variable '${node.name}' cannot use dynamic as a type annotation", node.beginToken.offset);
      }
    } else if (node is SimpleFormalParameter) {
      if (node.type == null) {
        printHint("Parameter '${node.element.name}' is missing a type annotation", node.beginToken.offset);
        found_errors = true;
      }
    }
    return super.visitNode(node);
  }
}

