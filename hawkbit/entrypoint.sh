#!/bin/sh
java -jar hawkbit-update-server.jar -Xmx768m -Xmx768m -XX:MaxMetaspaceSize=250m -XX:MetaspaceSize=250m -Xss300K -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+HeapDumpOnOutOfMemoryError --spring.config.location=/opt/hawkbit/application.properties
