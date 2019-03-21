#!/usr/bin/python
import xml.etree.ElementTree as ET

# XML to add
mysql_xml_string = \
    "<dependency>" \
        "<groupId>org.mariadb.jdbc</groupId>" \
        "<artifactId>mariadb-java-client</artifactId>" \
        "<version>2.3.0</version>" \
        "<type>jar</type>" \
        "<scope>compile</scope>" \
    "</dependency>"

# Register xml namespaces and parse
ET.register_namespace('', 'http://maven.apache.org/POM/4.0.0')
ET.register_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')

tree = ET.parse('pom.xml')
root = tree.getroot()

# Search for "dependencies" tag and add mysql dependency
for child in root:
    simplified_tag = (child.tag).split("}")[1]
    if simplified_tag == "dependencies":
        child.append(ET.XML(mysql_xml_string))
        break

tree.write('pom.xml')
