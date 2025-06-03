;; 1. Class names
(class_definition
  name: (identifier) @type)

;; 2. Bare imports (e.g., "import SOAP")
(import_statement
  name: (dotted_name (identifier) @type))

;; 3. Fix for non-standard import_from_structure in your parser
(import_from_statement
  . (dotted_name (identifier) @type))

;; 4. Fallback for ALL_CAPS (now LAST to avoid overriding imports)
[(identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$")]
