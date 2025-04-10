#!/bin/bash
black $(find . -type f -name "*.py" | tr '\n' ' ' | sed 's#\./##g')
