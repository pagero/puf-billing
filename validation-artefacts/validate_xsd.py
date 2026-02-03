#!/usr/bin/env python3
"""
XSD Validation Script for PUF Examples
Validates XML files against PageroUniversalFormat XSD schema
Automatically selects Invoice or CreditNote schema based on root element
"""

import sys
import os
from pathlib import Path
from lxml import etree

# Configuration
REPO_ROOT = Path(__file__).parent.parent  # puf-billing root
XSD_DIR = REPO_ROOT / "xml-schemas" / "maindoc"
INVOICE_XSD = XSD_DIR / "Pagero-Universal-Format-Invoice-2.1.xsd"
CREDITNOTE_XSD = XSD_DIR / "Pagero-Universal-Format-CreditNote-2.1.xsd"
EXAMPLES_DIR = REPO_ROOT / "examples"
XML_PATTERN = "**/*.xml"  # Recursive pattern


def get_root_element(xml_path: Path) -> str:
    """
    Get the root element name from an XML file.
    
    Returns:
        str: Root element local name (without namespace)
    """
    try:
        tree = etree.parse(str(xml_path))
        root = tree.getroot()
        # Get local name without namespace
        return etree.QName(root).localname
    except Exception as e:
        return None


def validate_xml_file(xml_path: Path, invoice_schema: etree.XMLSchema, creditnote_schema: etree.XMLSchema) -> tuple[bool, list[str], str]:
    """
    Validate a single XML file against the appropriate schema.
    
    Returns:
        tuple: (is_valid, error_messages, schema_used)
    """
    try:
        # Detect root element
        root_element = get_root_element(xml_path)
        
        if root_element is None:
            return False, ["Could not determine root element"], "Unknown"
        
        # Select appropriate schema
        if root_element == "Invoice":
            schema = invoice_schema
            schema_name = "Invoice"
        elif root_element == "CreditNote":
            schema = creditnote_schema
            schema_name = "CreditNote"
        else:
            return False, [f"Unknown root element: {root_element}"], "Unknown"
        
        # Parse XML
        xml_doc = etree.parse(str(xml_path))
        
        # Validate
        is_valid = schema.validate(xml_doc)
        
        if is_valid:
            return True, [], schema_name
        else:
            # Collect error messages
            errors = []
            for error in schema.error_log:
                errors.append(
                    f"Line {error.line}: {error.message}"
                )
            return False, errors, schema_name
            
    except etree.XMLSyntaxError as e:
        return False, [f"XML Syntax Error: {str(e)}"], "Unknown"
    except Exception as e:
        return False, [f"Exception: {str(e)}"], "Unknown"


def main():
    """Main validation routine."""
    
    print("\n=== XSD Validation Report (Python/lxml) ===\n")
    print(f"Invoice Schema: {INVOICE_XSD.name}")
    print(f"CreditNote Schema: {CREDITNOTE_XSD.name}")
    print(f"Examples directory: {EXAMPLES_DIR}")
    print()
    
    # Check if XSD files exist
    if not INVOICE_XSD.exists():
        print(f"[ERROR] Invoice XSD schema not found at: {INVOICE_XSD}")
        sys.exit(1)
    
    if not CREDITNOTE_XSD.exists():
        print(f"[ERROR] CreditNote XSD schema not found at: {CREDITNOTE_XSD}")
        sys.exit(1)
    
    # Check if examples directory exists
    if not EXAMPLES_DIR.exists():
        print(f"[ERROR] Examples directory not found at: {EXAMPLES_DIR}")
        sys.exit(1)
    
    # Load both XSD schemas
    try:
        print("Loading XSD schemas...")
        invoice_schema_doc = etree.parse(str(INVOICE_XSD))
        invoice_schema = etree.XMLSchema(invoice_schema_doc)
        print(f"[OK] Invoice schema loaded successfully")
        
        creditnote_schema_doc = etree.parse(str(CREDITNOTE_XSD))
        creditnote_schema = etree.XMLSchema(creditnote_schema_doc)
        print(f"[OK] CreditNote schema loaded successfully\n")
    except Exception as e:
        print(f"[ERROR] Failed to load XSD schemas: {e}")
        sys.exit(1)
    
    # Find XML files
    xml_files = sorted(EXAMPLES_DIR.glob(XML_PATTERN))
    
    if not xml_files:
        print(f"[ERROR] No XML files found in: {EXAMPLES_DIR}")
        sys.exit(1)
    
    print(f"Found {len(xml_files)} XML files to validate\n")
    print("-" * 80)
    
    # Validate each file
    valid_count = 0
    invalid_count = 0
    error_details = []
    schema_stats = {"Invoice": 0, "CreditNote": 0, "Unknown": 0}
    
    for xml_file in xml_files:
        # Get relative path for display
        try:
            rel_path = xml_file.relative_to(EXAMPLES_DIR)
        except ValueError:
            rel_path = xml_file.name
            
        is_valid, errors, schema_used = validate_xml_file(xml_file, invoice_schema, creditnote_schema)
        
        schema_stats[schema_used] = schema_stats.get(schema_used, 0) + 1
        
        if is_valid:
            print(f"[PASS] {rel_path} ({schema_used})")
            valid_count += 1
        else:
            print(f"[FAIL] {rel_path} ({schema_used})")
            invalid_count += 1
            error_details.append({
                'file': str(rel_path),
                'schema': schema_used,
                'errors': errors
            })
    
    # Summary
    print("\n" + "=" * 80)
    print(f"\n=== Summary ===")
    print(f"Total files:     {len(xml_files)}")
    print(f"[PASS] Valid:    {valid_count}")
    print(f"[FAIL] Invalid:  {invalid_count}")
    print(f"\nBy Schema:")
    print(f"  Invoice:       {schema_stats.get('Invoice', 0)}")
    print(f"  CreditNote:    {schema_stats.get('CreditNote', 0)}")
    if schema_stats.get('Unknown', 0) > 0:
        print(f"  Unknown:       {schema_stats.get('Unknown', 0)}")
    
    # Detailed errors
    if error_details:
        print(f"\n=== Detailed Validation Errors ===\n")
        for item in error_details:
            print(f"\n{item['file']} ({item['schema']}) - {len(item['errors'])} errors:")
            print("-" * 80)
            for i, error in enumerate(item['errors'], 1):
                print(f"{i}. {error}")
            print()
    
    print()
    return 0 if invalid_count == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
