
#import <Foundation/Foundation.h>

#import <clang-c/BuildSystem.h>
#import <clang-c/CXCompilationDatabase.h>
#import <clang-c/CXErrorCode.h>
#import <clang-c/CXString.h>
#import <clang-c/Documentation.h>
#import <clang-c/Index.h>
#import <clang-c/Platform.h>

int main(int argc, const char * argv[])
{
  const char *args[] = {
        "-I/usr/include",
        "-I."
  };
  
  const char *fileName = argv[1];

  int numArgs = sizeof(args) / sizeof(*args);

  CXIndex index = clang_createIndex(0, 0);
  CXTranslationUnit tu = clang_parseTranslationUnit(index, fileName, args, numArgs, NULL, 0, CXTranslationUnit_None);

  clang_visitChildrenWithBlock(clang_getTranslationUnitCursor(tu), ^(CXCursor cursor, CXCursor parent)
  {
    if( clang_getCursorKind(cursor) == CXCursor_VarDecl ||
              clang_getCursorKind(cursor) == CXCursor_ParmDecl ||
              clang_getCursorKind(cursor) == CXCursor_ObjCInterfaceDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCCategoryDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCProtocolDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCPropertyDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCIvarDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCInstanceMethodDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCClassMethodDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCImplementationDecl  ||
              clang_getCursorKind(cursor) == CXCursor_ObjCCategoryImplDecl
    ) 
    {
      CXSourceRange range = clang_getCursorExtent(cursor);
      CXSourceLocation location = clang_getRangeStart(range);
    
      CXFile file;
      unsigned line;
      unsigned column;
      clang_getFileLocation(location, &file, &line, &column, NULL);
    
      CXString filename = clang_getFileName(file);
      
      // fprintf(stderr, "%s:%u:%u: found variable %s\n", clang_getCString(filename), line, column, clang_getCString(name));
      
      if ((strstr(clang_getCString(filename), fileName) != NULL))
      {
        CXString name = clang_getCursorSpelling(cursor);

        fprintf(stderr, "%s:%u:%u: found variable %s\n", clang_getCString(filename), line, column, clang_getCString(name));
        clang_disposeString(name);
        clang_disposeString(filename);
      }
    }

    return CXChildVisit_Recurse;
  });

  clang_disposeTranslationUnit(tu);
  clang_disposeIndex(index);

  return 0;
}
  

      
      