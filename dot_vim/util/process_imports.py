import sys
import ast

def process_imports(file_path):
    with open(file_path, 'r') as file:
        code = file.read()

    tree = ast.parse(code)
    import_fullnames = []

    # Visit Import and ImportFrom nodes in the AST
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                fullname = alias.name
                import_fullnames.append(fullname)
        elif isinstance(node, ast.ImportFrom):
            module = node.module
            for alias in node.names:
                fullname = f"{module}.{alias.name}"
                import_fullnames.append(fullname)

    print("\n".join(import_fullnames))


if __name__ == "__main__":
    # Read arguments: file_path and project_root
    if len(sys.argv) < 2:
        print("Usage: process_imports.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]

    process_imports(file_path)

